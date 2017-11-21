# config/action_cable/config.ru
require_relative '../environment'
Rails.application.eager_load!

run ActionCable.server