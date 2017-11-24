require 'rails_helper'

module PunchClock
  RSpec.describe 'Cable connections', type: :system, js: true do

    before do

      visit '/users/sign_up'

      fill_in('Email',    with: 'fancyemail@domain.com')
      fill_in('Password', with: 'super_secret!')
      fill_in('Password confirmation', with: 'super_secret!')

      find_button('Sign up').click

    end


    it 'shows evidence of connection to the channels' do

      visit root_url

      click_on('Button') #TODO: find out why status 'online' is not shown even when clicking in something.
      # the weird thing is that if you click while the test driven browser shows up, the status 'online' shows up too.

      expect(page).to have_content('you are subscribed to PunchClock::UserActivityChannel')
      expect(page).to have_content('you are subscribed to PunchClock::ActivitySupervisionChannel')
      expect(page).to have_content('user with the id: 1 has the status: offline')

    end

  end
end