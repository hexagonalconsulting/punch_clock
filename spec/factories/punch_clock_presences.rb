FactoryBot.define do
  factory :punch_clock_presence, class: 'PunchClock::Presence' do
    status "online"
    last_time_browser_open   { Time.now.utc }
    last_time_browser_active { Time.now.utc }
  end
end
