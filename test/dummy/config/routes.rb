Rails.application.routes.draw do
  mount PunchClock::Engine => "/punch_clock"
  get '/examples' => 'examples#index'
end
