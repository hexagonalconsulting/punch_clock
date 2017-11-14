class User < ApplicationRecord
  has_one :presence, class_name: 'PunchClock::Presence'
end
