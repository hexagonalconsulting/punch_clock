require 'rails_helper'

RSpec.describe 'PunchClock::UserReportOfflineWorker' do

  let!(:user){create(:user)}

  before do
    Timecop.freeze
  end

  describe '2 minutes have passed since the user reported the browser as open' do

    before do
      user.presence.report_browser_as_open
      Timecop.travel(2.minutes.from_now)
    end

    describe 'user presence status is online' do

      it 'should change presence to offline if user have not reported any activity in the last minute' do
        PunchClock::UserReportOfflineWorker.new.perform
        expect(user.presence.reload.offline?).to eq(true)
      end

      it 'should not change presence to offline if user have reported the browser as open in the last minute' do
        user.presence.report_browser_as_open
        Timecop.travel(30.seconds.from_now)
        PunchClock::UserReportOfflineWorker.new.perform
        expect(user.presence.reload.offline?).to eq(false)
      end

    end

    describe 'user presence status is idle' do

      before do
        user.presence.set_idle
      end

      it 'should change presence to offline if user have not reported any activity in the last minute' do

        PunchClock::UserReportOfflineWorker.new.perform
        expect(user.presence.reload.offline?).to eq(true)

      end

      it 'should not change presence to offline if user have reported the browser as open in the last minute' do

        user.presence.report_browser_as_open
        Timecop.travel(30.seconds.from_now)
        PunchClock::UserReportOfflineWorker.new.perform
        expect(user.presence.reload.offline?).to eq(false)

      end

    end

  end
end