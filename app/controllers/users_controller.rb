class UsersController < ApplicationController
    get '/signup' do 
        if logged_in?
            @user = current_user
            erb :'/posts/index'
        else
            erb :'users/signup'
        end
    end

    post '/users' do
        
        if !params[:user][:username].include?(" ")
            user = User.new(params[:user])
            if user.save
                session[:user_id] = user.id
                @user = user
                redirect '/posts'
            end
        end     
        @error = "username or password are invalid"
        erb :'/users/signup'
    end

    get '/users/:id' do 
        if logged_in?
            @user = User.find_by_id(params[:id])
            erb :'/users/show'
        else
            erb :'/users/login'
        end
    end

    get '/login' do 
        if logged_in?
            @user = current_user
            erb :'/posts/show'
        else
            erb :'/users/login'
        end
    end

    get '/logout' do
        if logged_in?
            session.clear
            redirect '/'
        else
            redirect '/login'
        end
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

    post '/logout' do 
        session.clear
        redirect '/'
    end
end