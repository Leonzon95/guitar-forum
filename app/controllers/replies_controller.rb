class RepliesController < ApplicationController
    get '/posts/:post_id/replies/new' do 
        if logged_in?
            @post = Post.find_by_id(params[:post_id])
            erb :'/replies/new'
        else
            @error = "Please log in"
            erb :'/users/login'
        end
    end

    post '/posts/:post_id/replies' do 
        # binding.pry
        post = Post.find_by_id(params[:post_id])
        reply = current_user.replies.create(params[:reply])
        reply.post = post
        reply.save
        redirect "/posts/#{post.id}"
    end


    get '/posts/:post_id/replies/:id/edit' do 
        if logged_in?
            @reply = Reply.find_by_id(params[:id])
            erb :'/replies/edit'
        else
            @error = "Please log in"
            erb :'/users/login'
        end
    end

    delete '/replies/:id' do 
        reply = Reply.find_by_id(params[:id])
        post_id = reply.post.id
        reply.destroy
        redirect "/posts/#{post_id}"
    end 

    patch '/replies/:id' do 
        reply = Reply.find_by_id(params[:id])
        post_id = reply.post.id
        reply.update(params[:reply])
        redirect "/posts/#{post_id}"
    end
end