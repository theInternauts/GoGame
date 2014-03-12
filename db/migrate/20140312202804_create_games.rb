class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
    	t.string 	:current_board
    	t.string	:previous_board
    	t.integer 	:current_player_turn
    	t.string 	:game_score
    	t.timestamps
    end
  end
end
