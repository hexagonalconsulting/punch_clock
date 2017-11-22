FactoryBot.define do
  factory :user, class: 'User' do
    association :presence, factory: :punch_clock_presence
    email 'fancyemail@domain.com'
    password 'super_secret!'
    password_confirmation 'super_secret!'
  end
end