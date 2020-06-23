class UsersController < ApplicationController
    get '/signup' do 
        erb :'users/signup'
    end

    post '/users' do 
        user = User.new(params[:user])
        if user.save
            session[:user_id] = user.id
            @user = user
            redirect '/posts'
        else
            @error = "username or password are invalid"
            erb :'/users/signup'
        end
    end

    get '/login' do 
        erb :'/users/login'
    end

    post '/login' do 
        user = User.find_by(username: params[:user][:username])
        if user && user.authenticate(params[:user][:password])
            session[:user_id] = user.id
            @user = user
            redirect '/posts'
        else
            @error = "invalid username or password"
            erb :'/users/login'
        end
    end
end