require 'sinatra'
# require "#{Dir.pwd}/models/game"
# require "#{Dir.pwd}/views/*"
# require '../views/*'


get '/' do
  erb :index
end

post '/' do
  # select chip
end