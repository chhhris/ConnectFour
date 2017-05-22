require 'sinatra'
require 'byebug'

enable :sessions
# require "#{Dir.pwd}/models/game"
# require "#{Dir.pwd}/views/*"
# require '../views/*'

x = 6
y = 7
BOARD = y.times.map { Array.new(x, 0) }

helpers do

  def player
    session[:player]
  end

  def switch_turns
    if session[:player] == 'player1'
      session[:player] = 'player2'
    else
      session[:player] = 'player1'
    end
  end
end

get '/' do
  @player = session[:player] || 'player1'

  session[:board] ||= BOARD

  @board = session[:board]

  erb :index
end

post '/select' do

  if player == 'player1'
    session[:board][4][3] = 'o'
  else
    session[:board][3][4] = 'x'
  end

  switch_turns

  redirect '/'
end

post '/reset' do
  session[:board] = BOARD
  redirect '/'
end
