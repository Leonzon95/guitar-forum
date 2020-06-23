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
        if logged_in?
            @post = Post.find_by_id(params[:id])
            @user = @post.user
            erb :'posts/show'
        else
            @error = "Please log in"
            erb :'/users/login'
        end
    end

    delete '/posts/:id' do 
        post = Post.find_by_id(params[:id])
        post.destroy
        redirect '/posts'
    end

    get '/posts/:id/edit' do
        post = Post.find_by_id(params[:id])
        if !logged_in? 
            @error = "Please log in"
            erb :'/users/login'
        elsif current_user == post.user
            @post = post
            erb :'/posts/edit'
        else
            redirect '/posts'
        end
    end

    patch '/posts/:id' do 
        post = Post.find_by_id(params[:id])
        post.update(params[:post])
        redirect "/posts/#{post.id}"
    end
end