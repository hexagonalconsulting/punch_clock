require 'state_machines'
require 'state_machines-activerecord'

module PunchClock
  class Presence < ApplicationRecord
    belongs_to :user, class_name: 'User'
    ONLINE_TO_IDLE = 5.minutes
    ANY_TO_OFFLINE = 1.minutes

    state_machine :status, initial: :offline do
      state :online
      state :idle
      state :offline

      after_transition to: :online, except_from: :online,    do: :broadcast_status
      after_transition to: :idle, except_from: :idle,        do: :broadcast_status
      after_transition to: :offline, except_from: :offline,  do: :broadcast_status

      event :set_online do
        transition all => :online
      end

      event :set_offline do
        transition [:online, :idle] => :offline
      end

      event :set_idle do
        transition [:online, :idle] => :idle
      end

    end

    def should_be_idle?
      self.online? && self.last_time_browser_active < ONLINE_TO_IDLE.ago
    end

    def should_be_offline?
      self.last_time_browser_open <  ANY_TO_OFFLINE.ago
    end

    def report_browser_as_open
      self.last_time_browser_open  = Time.now.utc
      self.save!
      self.set_idle if  should_be_idle?
    end

    def report_browser_as_active
      self.last_time_browser_active  = Time.now.utc
      self.save!
      self.set_online
    end

    def broadcast_status
      ActiveSupport::Notifications.instrument 'user.presence_status',   id: user.id, status: self.status
    end

    class << self
      def subscribe_to_events!
        ActiveSupport::Notifications.subscribe('user.report_browser_as_active') do |name, start, finish, id, payload|
          Utils.run_if_allowed(name, start, finish, id, payload) do |name, start, finish, id, payload|
            user = User.hidrate(payload[:id])
            user.presence.report_browser_as_active
          end
        end


        ActiveSupport::Notifications.subscribe('user.report_browser_as_open') do |name, start, finish, id, payload|
          Utils.run_if_allowed(name, start, finish, id, payload) do |name, start, finish, id, payload|
            user = User.hidrate(payload[:id])
            user.presence.report_browser_as_open
          end
        end
      end
    end

  end
end
