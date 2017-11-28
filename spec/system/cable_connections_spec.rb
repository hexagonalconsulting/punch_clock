require 'rails_helper'

module PunchClock
  RSpec.describe 'Cable connections', type: :feature, js: true do

    let!(:user) { create(:user) }

    before { login_as(user, :scope => :user) }

    describe 'evidence of connection to the channels' do

      before { visit examples_path }

      it 'is in the right path, the one that all other test will be using' do
        expect(page).to have_current_path(examples_path)
      end

      it 'there is a user registered in the db  (the one just signed up in the before block)' do
        expect(User.count).to eq(1)
      end

      describe 'users without superadmin role' do

        it 'can connect to the users UserActivityChannel' do
          expect(page).to have_content('you are subscribed to PunchClock::UserActivityChannel')
        end

        it 'is rejected when trying to subscribe to the ActivitySupervisionChannel' do
          expect(page).to have_content('you were rejected from the PunchClock::ActivitySupervisionChannel')
        end

      end

      describe 'users with superadmin role' do

        let!(:user) { create(:user, superadmin: true) }

        it 'can connect to the users UserActivityChannel' do
          expect(page).to have_content('you are subscribed to PunchClock::UserActivityChannel')
        end

        it 'can connect to the ActivitySupervisionChannel' do
          expect(page).to have_content('you are subscribed to PunchClock::ActivitySupervisionChannel')
        end

        it 'get updates from a user using the subscription to the ActivitySupervisionChannel' do
          sleep(1)
          expect(page).to have_content('user with the id: 1 has the status: online')
        end

      end

    end

  end
end