module PunchClock
  class ActivitySupervisionChannel < ApplicationCable::Channel

    def subscribed
      if current_user.superadmin?
        user = User.find(params[:id])
        stream_for user
        broadcast_status_for(user.id)
      else
        reject
      end
    end

    def unsubscribed
    end

    delegate :broadcast_status_for, to: :class

    class << self
      def broadcast_status_for(id, status= nil)

        user = User.find(id)
        status = status || user.presence.status

        broadcast_to(user,    {status: status,   id: user.id})
      end

      def subscribe_to_events!
        ActiveSupport::Notifications.subscribe('user.presence_status') do |name, start, finish, id, payload|

          ActivitySupervisionChannel.broadcast_status_for(payload[:id], payload[:status])

        end
      end
    end

  end
end