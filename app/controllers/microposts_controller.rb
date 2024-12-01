# frozen_string_literal: true

# The User model represents a user in the application.
# It is responsible for handling user authentication, registration,
# profile management, and other user-related functionality.
# This model is associated with several other models like `Post`, `Relationship`,
# and more. It uses features like secure password authentication and
# token generation for password resets.
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user,   only: [:destroy]
  def create
    build_micropost
    attach_image
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted!'
    redirect_to request.referer
  end

  def show
    @micropost = Micropost.find_by(id: params[:id])

    if @micropost.nil?
      flash[:info] = 'Micropost not found'
      redirect_to root_url
    else
      @comments = @micropost.replies.includes(:user)
    end
  end

  def edit
    @micropost = Micropost.find_by(id: params[:id])
  end

  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update(micropost_params)
      flash[:success] = 'Micropost was successfully updated'
      redirect_to micropost_path(@micropost)
    else
      render :edit
    end
  end

  def create_comment
    build_comment
    if @micropost.save
      redirect_to request.referer
    else
      redirect_to request.referer || root_path
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

  def build_micropost
    @micropost = current_user.microposts.build(micropost_params)
  end

  def attach_image
    @micropost.image.attach(params[:micropost][:image])
  end

  def comment_params
    params.permit(:content, :parent_id)
  end

  def build_comment
    @micropost = current_user.microposts.build(comment_params)
  end
end
