class RepliesController < ApplicationController
    get '/posts/:post_id/replies/new' do 
        post = Post.find_by_id(params[:post_id])
        if logged_in? && post
            @post = post
            erb :'/replies/new'
        elsif logged_in?
            redirect '/posts'
        else
            @error = "Please log in"
            erb :'/users/login'
        end
    end

    post '/posts/:post_id/replies' do 
        post = Post.find_by_id(params[:post_id])
        if post && !params[:reply][:content].empty?
            reply = current_user.replies.create(params[:reply])
            reply.post = post
            reply.save
            redirect "/posts/#{post.id}"
        elsif post
            redirect '/posts'
        else
            @error = "Your reply can't be empty"
            erb :'/replies/new'
        end
    end


    get '/posts/:post_id/replies/:id/edit' do 
        reply = Reply.find_by_id(params[:id])
        if logged_in? && reply
            @reply = reply
            erb :'/replies/edit'
        elsif logged_in?
            redirect '/posts'
        else
            @error = "Please log in"
            erb :'/users/login'
        end
    end

    delete '/replies/:id' do 
        reply = Reply.find_by_id(params[:id])
        if reply && reply.user == current_user
            post_id = reply.post.id
            reply.destroy
            redirect "/posts/#{post_id}"
        elsif reply
            redirect "/posts/#{reply.post.id}"
        else
            redirect "/posts"
        end
    end

    patch '/replies/:id' do
        reply = Reply.find_by_id(params[:id])
        if reply && reply.user == current_user
            post_id = reply.post.id
            reply.update(params[:reply])
            redirect "/posts/#{post_id}"
        elsif reply
            redirect "/posts/#{reply.post.id}" 
        else
            redirect '/posts'
        end
    end
end