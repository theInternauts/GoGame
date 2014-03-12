class ChangeScoreColumnInGames < ActiveRecord::Migration
  def up
    remove_column :games, :game_score
    add_column :games, :player_white_uid, :integer
    add_column :games, :player_black_uid, :integer
    add_column :games, :player_white_score, :integer
    add_column :games, :player_black_score, :integer
  end

  def down
    add_column :games, :game_score, :string
    remove_column :games, :player_white_uid
    remove_column :games, :player_black_uid
    remove_column :games, :player_white_score
    remove_column :games, :player_black_score 
  end
end
