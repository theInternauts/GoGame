class GamesController < ApplicationController
  before_filter :get_current_user

  def index
    @active_games = Game.where(:active => true)
    @inactive_games = Game.where(:active => false)
  end

  def show
    
  end

  def new
    @new_game = current_user.games.build(:player_white_uid => current_user.id)
  end

  def get_current_user
    @user = current_user
  end
end