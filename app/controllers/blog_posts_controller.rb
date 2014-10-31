class BlogPostsController < ApplicationController
  before_action :authenticate_admin!, only: [:edit, :new, :destroy, :update, :approval_queue]

  def index
    @blog_posts = BlogPost.approved.order(:published_at)
  end

  def show
    @blog_post = BlogPost.find(params[:id])
  end

  def new
    @blog_post = BlogPost.new
  end

  def update
    blog_post = BlogPost.find(params[:id])
    blog_post.update_attributes(blog_post_params)
      if blog_post.save
        flash[:notice] = "Successfully updated blog post."
        redirect_to blog_post_path(blog_post)
      else
        flash[:alert] = "Could not update blog post."
        render :new
      end
  end

  def edit
    @blog_post = blog_post.find(params[:id])
  end

  def destroy
    blog_post = BlogPost.find(params[:id])
    if blog_post.destroy
      flash[:notice] = "Successfully deleted."
    else
      flash[:alert] = "Could not delete."
    end
    redirect_to blog_posts_path
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title, :body, :approved)
  end

end
