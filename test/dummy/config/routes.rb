Rails.application.routes.draw do
  devise_for :users
  mount PunchClock::Engine => "/punch_clock"
  get '/examples' => 'examples#index'
  root to: 'examples#index'
end
