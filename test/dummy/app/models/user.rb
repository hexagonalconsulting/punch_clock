class User < ApplicationRecord
  has_one :presence, class_name: 'PunchClock::Presence'

  def presence
    super || create_presence!(user: self)
  end
end
