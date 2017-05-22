require 'sinatra'
require "#{Dir.pwd}/models/game.rb"
require 'rack/env'
require 'byebug'

use Rack::Env
enable :sessions

helpers do

  def start_game
    session.clear
    game = session[:game] = Game.new
    session[:board] = game.new_board
  end

  def game
    session[:game]
  end

  # get the player's name when initializing 1Player vs Computer !?!?
  def player
    session[:player] ||= 'player1'
  end

  def switch_turns
    session[:player] = player == 'player1' ? 'player2' : 'player1'
  end
end

get '/' do
  start_game
  @player = player
  @board = session[:board]

  erb :index
end

post '/move' do
  updated_board = game.update_board(session[:board], params[:slot].to_i, player)
  session[:board] = updated_board
  switch_turns

  redirect '/in_progress'
end

get '/in_progress' do
  @board = session[:board]
  @player = player

  erb :index
end

post '/reset' do
  session.clear
  redirect '/'
end
