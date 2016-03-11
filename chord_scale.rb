require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'
require './chord_scale_builder'


configure do
  enable :sessions
  set :session_secret, 'secret'
end

get "/" do
  erb :choose_root
end

post "/" do
  session[:root] = params[:root]
  @root = params[:root]
  erb :choose_collection_type
end

post "/collection" do
  session[:collection] = params[:collection]
  @collection = session[:collection]
  if session[:collection] == 'scale'
    source = YAML.load_file('scales.yml')
  else
    source = YAML.load_file('chords.yml')
  end
  @qualities = source.to_a.map {|arr| [arr[1][1], arr[0]] }
  erb :quality
end

post "/quality" do
  session[:quality] = params[:quality]
  @quality = session[:quality]
  @root = session[:root]
  "#{@root} #{@quality}"
end
