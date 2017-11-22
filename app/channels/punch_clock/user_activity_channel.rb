module PunchClock
  class UserActivityChannel < ApplicationCable::Channel

    def subscribed
      # stream_from "some_channel"
    end

    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end

    def report_browser_as_active
      ActiveSupport::Notifications.instrument 'user.report_browser_as_active',
                                              id: current_user.id

    end

    def report_browser_as_open
      ActiveSupport::Notifications.instrument 'user.report_browser_as_open',
                                              id: current_user.id
    end

  end
end
