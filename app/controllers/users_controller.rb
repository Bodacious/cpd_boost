class UsersController < ApplicationController
  
  before_action :set_user_params, only: [:show, :edit, :update]
  before_action :set_post_params, only: [:bookmark, :remove_bookmark]
  before_action :require_same_user, only: [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You have successfully registered!  Welcome to PostIt #{current_user.username}."
      redirect_to root_path
    else
      render :new
    end
  end
  
  def show; end
  
  def edit; end
  
  def update
    if @user.update(user_params)
      flash[:notice] = "#{current_user.username}, you have successfully updated your profile!"
      redirect_to user_path(@user)
    else
      render :edit
    end  
  end
  
  #create a post reference in saved_posts
  def bookmark
    @bookmark = BookmarkedPost.create(creator: current_user, post_id: @post.id)
    
    respond_to do |format|
      format.html do
        redirect_to :back
      end
      format.js { render 'change' }
    end
  end
  
  #remove the post reference from saved_posts
  def remove_bookmark
    @bookmark = BookmarkedPost.find_by(creator: current_user, post_id: @post.id)
    @bookmark.destroy
    
    render 'change'
  
  end
  
  private
  
  def set_user_params
    @user = User.find_by(slug: params[:id])
  end
  
  def set_post_params
    @post = Post.find_by(slug: params[:id])
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :time_zone, :password)
  end
  
  def require_same_user
    if current_user != @user
      flash[:danger] = "You're not allowed to do that"
      redirect_to root_path
    end
  end
  
end