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
        if !params[:post][:title].empty?
            user.posts.create(params[:post])    
            post = user.posts.last
            redirect "/posts/#{post.id}"
        else
            @error = "Your title can't be empty"
            erb :'/posts/new'
        end
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
        if post.user == current_user
            post.replies.each do |reply|
                reply.destroy
            end
            post.destroy
            redirect '/posts'
        else
            redirect '/posts'
        end
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
        if post.user == current_user
            post.update(params[:post])
            redirect "/posts/#{post.id}"
        else
            redirect "/posts/#{post.id}"
        end
    end
end