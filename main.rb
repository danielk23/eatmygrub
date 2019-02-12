### TOOLS / SOFTWARE USED ###    
require 'sinatra'
# require 'sinatra/reloader'
# require 'pry'
require 'pg'
require 'active_record'

### CONFIG RELATIVE LINK ###
require_relative 'db_config'
require_relative 'models/event'
require_relative 'models/user'

### SINATRA (storing session/checking hash table - crypt user password string is true) ###
enable :sessions

### HELPERS METHODS ###
helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    if current_user
      return true
    else
      return false
    end
  end
end


### ROUTES ###

## HOMEPAGE ##
get '/' do
  erb :index, {layout: false} # false could be change to another file name, basically to use that template(erb) instead of layout
end


## USERS ##

get '/sign_up' do
  erb :sign_up, {layout: false}
end

post '/sign_up' do
user = User.new
user.username = params[:username]
user.first_name = params[:first_name]
user.last_name = params[:last_name]
user.email = params[:email]
user.password = params[:password]
user.save
redirect '/login'
end


get '/login' do
  erb :login, {layout: false}
end

post '/session' do
  user = User.find_by(email: params[:email])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id

    redirect '/events'
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/login'
end

get '/search' do
  search = params[:search_query]
  @events = Event.where(location_event: search, guest_id: nil)
  erb :search_event
end


## EVENT(all events page) ##

get '/events' do
  @events = Event.where(guest_id: nil)
  erb :events
end


## MY EVENTS (all users events)##

get '/my_events' do
  redirect '/login' unless logged_in?

  @events = Event.where(user_id: current_user.id)
  erb :my_events
end

get '/my_event/new' do
  redirect '/login' unless logged_in?
  erb :my_event_new
end

post '/my_event/new' do
  redirect '/login' unless logged_in?

  event = Event.new
  event.date_event = params[:date_event]
  event.time_event = params[:time_event]
  event.location_event = params[:location_event]
  event.nbr_guest = params[:nbr_guest]
  event.food_category = params[:food_category]
  event.menu_description = params[:menu_description]
  event.price = params[:price]
  event.image_url = params[:image_url]
  event.user_id = current_user.id
  event.save

  redirect "/my_event/#{event.id}/detail"
end

get '/my_event/:id/detail' do
  redirect '/login' unless logged_in?

  @event = Event.find(params[:id])
  erb :my_event_detail
end

delete '/my_event/:id/detail' do
  redirect '/login' unless logged_in?
  
  @event = Event.find(params[:id])
  @event.destroy
  redirect '/my_events'
end


get '/my_event/:id/edit' do
  redirect '/login' unless logged_in?
  
  @event = Event.find(params[:id])
  erb :my_event_edit
end

put '/my_event/:id' do
  redirect '/login' unless logged_in?
  
  event = Event.find(params[:id])
  event.date_event = params[:date_event]
  event.time_event = params[:time_event]
  event.location_event = params[:location_event]
  event.nbr_guest = params[:nbr_guest]
  event.food_category = params[:food_category]
  event.menu_description = params[:menu_description]
  event.price = params[:price]
  event.image_url = params[:image_url]
  event.save
  redirect "/my_events"
end

## RESERVE - BOOK EVENT

get '/my_reserved_events' do
  redirect '/login' unless logged_in?
  
  @events = Event.where(guest_id: current_user.id)
  erb :my_event_reserve
end

post '/my_event/:id/reserve' do
  redirect '/login' unless logged_in?

  event = Event.find(params[:id])
  event.guest_id = current_user.id
  event.save

  redirect "/my_reserved_events"
end


