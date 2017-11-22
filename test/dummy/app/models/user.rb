class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :presence, class_name: 'PunchClock::Presence'

  def presence
    super || create_presence!(user: self)
  end
end
