class RepliesController < ApplicationController
    get '/posts/:post_id/replies/new' do 
        post = Post.find_by_id(params[:post_id])
        log_in_required
        if post
            @post = post
            erb :'/replies/new'
        else
            redirect '/posts'
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
        log_in_required
        if reply
            @reply = reply
            erb :'/replies/edit'
        else
            redirect '/posts'
        end
    end

    delete '/replies/:id' do 
        authorization_required
        reply = Reply.find_by_id(params[:id])
        if reply
            post_id = reply.post.id
            reply.destroy
            redirect "/posts/#{post_id}"
        else
            redirect "/posts"
        end
    end

    patch '/replies/:id' do
        authorization_required
        reply = Reply.find_by_id(params[:id])
        if reply
            post_id = reply.post.id
            reply.update(params[:reply])
            redirect "/posts/#{post_id}"
        else
            redirect '/posts'
        end
    end

    helpers do
        def authorization_required
            unless @reply = current_user.replies.find_by_id(params[:id])
                redirect "/posts"
            end
        end
    end
end