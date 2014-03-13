class User < ActiveRecord::Base
  attr_accessible :email, :password
  include Clearance::User
  has_and_belongs_to_many :games
end
