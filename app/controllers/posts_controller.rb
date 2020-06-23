class PostsController < ApplicationController
    get '/posts' do 
        if logged_in?
            @user = current_user
            erb :'/posts/index'
        else
            @error = "Please log in"
            erb :'/users/login'
        end
    end

    get '/posts/new' do
        if logged_in?
            @user = current_user
            erb :'/posts/new'
        else
            @error = "Please log in"
            erb :'/users/login'
        end
    end

    post '/posts' do 
        user = current_user
        user.posts.create(params[:post])
        redirect '/posts'
    end

    get '/posts/:id' do 
        @post = Post.find_by_id(params[:id])
        erb :'posts/show'
    end
end