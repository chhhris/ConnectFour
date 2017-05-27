require 'sinatra'
require "#{Dir.pwd}/models/game.rb"
require 'rack/env'

use Rack::Env
enable :sessions
set :raise_errors, false
set :show_exceptions, false

helpers do
  def game
    session[:game]
  end

  def switch_turns
    game.current_player = begin
      if game.num_players > 1
        Game::SWITCH_PLAYERS[game.current_player]
      else
        Game::TOGGLE_CPU_TURN[game.current_player]
      end
    end
  end
end

get '/' do
  @game = session[:game] = Game.new

  erb :index
end

get '/game_in_progress' do
  @game = game
  @board = game.board
  @current_player = game.current_player

  if @current_player == Game::COMPUTER
    game.execute_computer_move

    if game.connect_four || game.over
      redirect to '/game_over'
    else
      switch_turns
      redirect to '/game_in_progress'
    end
  end

  erb :index
end

get '/game_over' do
  @current_player = game.current_player
  @game = game
  @board = game.board

  erb :game_over
end

post '/set_players' do
  game.num_players = params[:num_players].to_i

  redirect to '/game_in_progress'
end

post '/drop_checker' do
  game.board = game.process_move_and_return_board(game.board, params[:slot].to_i, game.current_player)

  if game.connect_four || game.over
    redirect to '/game_over'
  else
    switch_turns
    redirect to '/game_in_progress'
  end
end

post '/start_new_game' do
  session.clear

  redirect to '/'
end

error 500 do
  session.clear
  redirect to '/'
end

error 404 do
  path = game.nil? ? '/' : '/game_in_progress'
  redirect to path
end
