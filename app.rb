require 'sinatra'
require "#{Dir.pwd}/models/game.rb"
require "#{Dir.pwd}/models/board.rb"
require 'rack/env'
require 'byebug'

use Rack::Env
enable :sessions

helpers do
  PLAYER1 = 'Player 1'
  PLAYER2 = 'Player 2'

  SWITCH_PLAYERS = {
    PLAYER2 => PLAYER1,
    PLAYER1 => PLAYER2
  }

  # MOVE THIS LOGIC TO GAME CLASS
  def start_game
    session.clear
    game = session[:game] = Game.new
    session[:board] = game.board
  end

  def game
    session[:game]
  end

  # get the player's name when initializing 1Player vs Computer !?!?
  def current_player
    session[:current_player] ||= PLAYER1
  end

  def switch_turns
    # TO DO
    # player2 = num_players == 1 ? PLAYER2 : 'Computer'
    session[:current_player] = SWITCH_PLAYERS[current_player]
  end

  def num_players
    session[:num_players]
  end
end

# TO DO redirect any 404s or 500s to root ('/')

get '/' do
  if num_players.nil?
    @num_players_unset = true
  else
    start_game
    @current_player = current_player
    @board = session[:board]
  end

  erb :index
end

post '/move' do
  updated_board = game.update_board(session[:board], params[:slot].to_i, current_player)
  session[:board] = updated_board
  switch_turns

  redirect '/in_progress'
end

get '/in_progress' do
  @board = session[:board]
  @current_player = current_player

  erb :index
end

post '/set_players' do
  session[:num_players] = params[:num_players].to_i
  redirect '/'
end

post '/reset' do
  session.clear
  redirect '/'
end
