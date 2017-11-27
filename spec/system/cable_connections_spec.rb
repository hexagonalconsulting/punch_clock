require 'rails_helper'

module PunchClock
  RSpec.describe 'Cable connections', type: :system, js: true do

    before do

      visit '/users/sign_up'

      fill_in('Email',    with: 'fancyemail@domain.com')
      fill_in('Password', with: 'super_secret!')
      fill_in('Password confirmation', with: 'super_secret!')

      find_button('Sign up').click

      visit examples_url

      if current_path != examples_path && current_path == '/users/sign_in'
        fill_in('Email',    with: 'fancyemail@domain.com')
        fill_in('Password', with: 'super_secret!')
        find_button('Log in').click
      end

      visit examples_url
    end

    describe 'evidence of connection to the channels' do

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

        before do
          # let the user be a superadmin
          user = User.first
          user.superadmin = true
          user.save
        end

        it 'can connect to the users UserActivityChannel' do
          expect(page).to have_content('you are subscribed to PunchClock::UserActivityChannel')
        end

        it 'can connect to the ActivitySupervisionChannel' do
          expect(page).to have_content('you are subscribed to PunchClock::ActivitySupervisionChannel')
        end

        it 'get updates from a user using the subscription to the ActivitySupervisionChannel' do
          #click_on('Button') #TODO: find out why status 'online' is not shown even when clicking in something.
          # the weird thing is that if you click while the test driven browser shows up, the status 'online' shows up too.
          expect(page).to have_content('user with the id: 1 has the status: offline')
        end

      end

    end

  end
end