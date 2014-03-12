class AddStatsToUsers < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.integer :lifetime_points
  		t.integer :wins
  		t.integer :losses
  		t.integer :draws
  	end
  end
end
