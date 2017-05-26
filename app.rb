require 'sinatra'
require "#{Dir.pwd}/models/game.rb"
require 'rack/env'
require 'byebug'

use Rack::Env
enable :sessions

helpers do

  def game
    session[:game]
  end

  def switch_turns
    game.current_player = Game::SWITCH_PLAYERS[game.current_player]

    # session[:current_player] = begin
    #   if session[:num_players] > 1
    #     Game::SWITCH_PLAYERS[current_player]
    #   else
    #     Game::TOGGLE_CPU_TURN[current_player]
    #   end
    # end
  end

end

# TO DO redirect any 404s or 500s to root ('/')

get '/' do
  @game = session[:game] = Game.new

  # if game.nil? || game.num_players.nil?

  # else
  #   @current_player = current_player
  #   @board = game.board
  # end

  erb :index
end

get '/in_progress' do
  @game = game
  @board = game.board
  @current_player = game.current_player

  if @current_player == Game::COMPUTER
    game.execute_computer_move
    switch_turns
    redirect to '/in_progress'
  end

  erb :index
end

get '/game_over' do
  @current_player = game.current_player
  @game = game

  erb :game_over
end

post '/set_players' do
  game.num_players = params[:num_players].to_i
  redirect to '/in_progress'
end

post '/move' do
  game.board = game.process_move(game.board, params[:slot].to_i, game.current_player)

  if game.connect_four || game.over
    redirect to '/game_over'
  else
    switch_turns
    redirect to '/in_progress'
  end
end

post '/reset' do
  session.clear
  redirect '/'
end
