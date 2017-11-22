require 'rails_helper'

module PunchClock
  RSpec.describe Presence, type: :model do
    let!(:user) { create(:user)}
    let(:presence) { user.presence}

    before do
      Timecop.freeze
    end

    describe 'instance methods' do

      describe '#report_browser_as_open' do

        it 'should change status to :idle if the user has not report activity in the last 5 minutes' do
          Timecop.travel(5.minutes.from_now)
          presence.report_browser_as_open
          expect(presence.idle?).to be_truthy
        end

        it 'should not change status to :idle if the user has  report activity in the last 5 minutes' do
          Timecop.travel(4.minutes.from_now)
          presence.report_browser_as_open
          expect(presence.idle?).to be_falsey
        end

      end

    end

    describe 'events in the state machine' do

      describe  'the :set_online event' do

        it  'should change status from :offline to :online' do

          presence.status = 'offline'
          presence.save!
          presence.report_browser_as_active
          expect(presence.reload.online?).to be_truthy

        end

        it  'should change status from :idle to :online' do

          presence.status = 'idle'
          presence.save!
          presence.report_browser_as_active
          expect(presence.reload.online?).to be_truthy

        end

        it  'should broadcast the :online status when browser is reported to be active but status is not online' do

          presence.status = 'offline'
          presence.save

          called, payload = notification_payload_for('user.presence_status') do
            presence.report_browser_as_active
          end

          expect(called).to be_truthy
          expect(payload).to eq(id: presence.user.id, status: 'online')
        end

        it  'should not broadcast the :online status when browser is reported to be active and the status is already online' do

          expect(presence).to be_online

          called, payload = notification_payload_for('user.presence_status') do
            presence.report_browser_as_active
          end

          expect(called).to be_falsey
        end

      end

      describe  'the :set_idle event' do

        it  'should change status from :online to :idle' do

          presence.status = 'online'
          presence.save!
          presence.set_idle
          expect(presence.reload.idle?).to be_truthy

        end

        it  'status should remain :idle' do

          presence.status = 'idle'
          presence.save!
          presence.set_idle
          expect(presence.reload.idle?).to be_truthy

        end


        it  'should not change status from :offline to :idle' do

          presence.status = 'offline'
          presence.save!
          presence.set_idle
          expect(presence.reload.idle?).to be_falsey

        end

        it  'should broadcast the :idle status' do
          called, payload = notification_payload_for('user.presence_status') do
            presence.set_idle
          end

          expect(called).to be_truthy
          expect(payload).to eq(id: presence.user.id, status: 'idle')

        end

        it  'should not broadcast the :idle status if current status is :offline' do

          presence.status = 'offline'
          presence.save!


          called, payload = notification_payload_for('user.presence_status') do
            presence.set_idle
          end

          expect(called).to be_falsey
        end

      end

      describe  'the :set_offline event' do

        it  'should change status from :online to :offline' do

          presence.status = 'online'
          presence.save!
          presence.set_offline
          expect(presence.reload.offline?).to be_truthy

        end

        it  'should change status from :idle to :offline' do

          presence.status = 'idle'
          presence.save!
          presence.set_offline
          expect(presence.reload.offline?).to be_truthy

        end

        it  'should broadcast the :offline status' do


          called, payload = notification_payload_for('user.presence_status') do
            presence.set_offline
          end

          expect(called).to be_truthy
          expect(payload).to eq(id: presence.user.id, status: 'offline')

        end

      end

    end

    describe 'intrumentation hooks' do

      it 'changes last_time_browser_open value when the instrumentation call is triggered' do

        the_value_before_the_instrumentation_call  = presence.last_time_browser_open.to_s

        Timecop.freeze(5.minutes.from_now)

        # This call to instrumentation API plays the role of the #report_browser_as_open in the UserActivityChannel.
        ActiveSupport::Notifications.instrument 'user.report_browser_as_open',
                                                  id: presence.user.id

        the_value_now = presence.reload.last_time_browser_open.to_s

        expect(the_value_now).to eq(Time.now.getutc.to_s)

        expect(the_value_now).not_to eq(the_value_before_the_instrumentation_call)

      end

    end

  end
end
