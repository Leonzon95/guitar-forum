class UsersController < ApplicationController
    get '/signup' do 
        if logged_in?
            @user = current_user
            erb :'/posts/index'
        else
            erb :'users/signup'
        end
    end

    post '/signup' do 
        if !params[:user][:username].include?(" ")
            user = User.new(params[:user])
            if user.save
                session[:user_id] = user.id
                redirect '/posts'
            end
        end     
        @error = "username or password are invalid"
        erb :'/users/signup'
    end

    get '/users/:id' do 
        user = User.find_by_id(params[:id])
        if logged_in? && user
            @user = user
            erb :'/users/show'
        else
            redirect '/login'
        end
    end

    get '/login' do 
        if logged_in?
            redirect '/posts'
        else
            erb :'/users/login'
        end
    end

    get '/logout' do
        log_in_required
        session.clear
        redirect '/'
    end

    post '/login' do 
        user = User.find_by(username: params[:user][:username])
        if user && user.authenticate(params[:user][:password])
            session[:user_id] = user.id
            redirect '/posts'
        else
            @error = "invalid username or password"
            erb :'/users/login'
        end
    end
end