require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET']
    set :show_exceptions, true
  end

  get "/" do
    if !logged_in?
      erb :index
    else
      redirect '/posts'
    end
  end

  not_found do
    erb :not_found
  end

  error ActiveRecord::RecordNotFound do
    redirect '/posts'
  end

  helpers do 
    def logged_in?
      !!session[:user_id]
    end

    def log_in_required
      if !logged_in?
        redirect '/login'
      end
    end

    def current_user
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    end

  end

  private
    #write methods
end
