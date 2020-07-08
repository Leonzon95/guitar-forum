class PostsController < ApplicationController
    get '/posts' do 
        log_in_required
        @posts = Post.all
        erb :'/posts/index'
    end

    get '/posts/new' do
        log_in_required
        erb :'/posts/new'
    end

    post '/posts' do 
        log_in_required
        if !params[:post][:title].blank? && !params[:post][:content].blank?
            post = current_user.posts.create(params[:post])    
            redirect "/posts/#{post.id}"
        else
            @error = "Your title or content can't be empty"
            erb :'/posts/new'
        end
    end

    get '/posts/:id' do 
        post = Post.find_by_id(params[:id])
        if logged_in? && post
            @post = post
            erb :'posts/show'
        elsif logged_in?
            erb :not_found
        else
            redirect '/login'
        end
    end

    # delete '/posts/:id' do
    #     post = Post.find_by_id(params[:id])
    #     if post && post.user == current_user
    #         post.replies.each do |reply|
    #             reply.destroy
    #         end
    #         post.destroy
    #     end
    #     redirect '/posts'
    # end
    delete '/posts/:id' do
        log_in_required
        authorization_required
        post = Post.find_by_id(params[:id])
        post.replies.each do |reply|
            reply.destroy
        end
        post.destroy
        redirect '/posts'
    end

    get '/posts/:id/edit' do
        post = Post.find_by_id(params[:id])
        if !logged_in? 
            @error = "Please log in"
            erb :'/users/login'
        elsif post && current_user == post.user 
            @post = post
            erb :'/posts/edit'
        else
            redirect '/posts'
        end
    end
    
    get '/posts/:id/edit' do
        log_in_required
        authorization_required
        @post = Post.find_by_id(params[:id])
        erb :'/posts/edit'
   end

    patch '/posts/:id' do 
        post = Post.find_by_id(params[:id])
        authorization_required
        post.update(params[:post])
        redirect "/posts/#{post.id}"   
    end

    helpers do
        def authorization_required
            unless @post = current_user.posts.find_by_id(params[:id])
                redirect "/posts"
            end
        end
    end
end