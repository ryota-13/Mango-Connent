class Admin::PostsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @posts = Post.includes(:user, :comments).order(created_at: :desc).page(params[:page]).per(16) 
  end
  
  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to admin_posts_path
  end

end
