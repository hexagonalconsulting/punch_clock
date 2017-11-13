Rails.application.routes.draw do
  mount PunchClock::Engine => "/punch_clock"
end
