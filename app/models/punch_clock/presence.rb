module PunchClock
  class Presence < ApplicationRecord
    belongs_to :user, class_name: 'User'
  end
end
