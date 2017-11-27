module PunchClock
  class UserReportOfflineWorker
    include Sidekiq::Worker
    sidekiq_options :retry => 0

    def perform

      idle_presences = PunchClock::Presence.where(status: 'idle').or(PunchClock::Presence.where(status: 'online'))

      idle_presences.each do |presence|
        if presence.should_be_offline?
          presence.set_offline
        end
      end

    end
  end
end