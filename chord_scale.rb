require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'
require './csbuilder'

def source
  if session[:collection] == 'scale'
    YAML.load_file('scales.yml')
  elsif session[:collection] == 'chord'
    YAML.load_file('chords.yml')
  end
end

def check_root
  unless session[:root]
    session[:error] = "Please choose a root note first"
    redirect "/"
  end
end

def check_collection
  unless session[:collection]
    session[:error] = "Please choose a chord or scale first."
    redirect "/collection"
  end
end

def check_quality
  unless session[:quality]
    session[:error] = "Please choose a chord/scale type first"
    redirect "/quality"
  end
end

configure do
  enable :sessions
  set :session_secret, 'secret'
end

get "/" do
  erb :choose_root
end

post "/" do
  session[:root] = params[:root]
  redirect "/collection"
end

get "/collection" do
  check_root
  @root = session[:root]
  erb :choose_collection_type
end

post "/collection" do
  session[:collection] = params[:collection]
  redirect "/quality"
end

get "/quality" do
  check_root
  check_collection
  @collection = session[:collection]
  @qualities = source.to_a.map {|arr| [arr[1][1], arr[0]] }
  erb :quality
end


post "/quality" do
  session[:quality] = params[:quality].to_sym
  redirect "/result"
end

get "/result" do
  check_root
  check_collection
  check_quality
  @quality = session[:quality]
  @root = session[:root]
  @col = Collection.new(@root, @quality, source)
  erb :result
end

get "/reset" do
  session.clear
  redirect "/"
end

not_found do
  redirect "/"
end
