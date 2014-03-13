class Game < ActiveRecord::Base
	attr_accessible :player_white_uid, :player_black_uid

  has_and_belongs_to_many :users

end
