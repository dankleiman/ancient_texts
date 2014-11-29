class BlogPostsController < ApplicationController
  before_action :authenticate_admin!, only: [:edit, :new, :destroy, :update, :approval_queue]
  layout 'admin', only: [:approval_queue, :edit]

  def index
    @blog_posts = BlogPost.published.paginate(:page => params[:page])
  end

  def feed
    @blog_posts = BlogPost.published

    respond_to do |format|
     format.atom { render :layout => false }
    end
  end

  def show
    @blog_post = BlogPost.find(params[:id])
  end

  def new
    @blog_post = BlogPost.new
  end

  def approval_queue
    @pending_approval = BlogPost.where(approved: false).order(:published_at)
    @pending_publication = BlogPost.approved.where('published_at > ?', Date.today)
    @missing_dates = BlogPost.where(published_at: nil)
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
    @blog_post = BlogPost.find(params[:id])
  end

  def destroy
    blog_post = BlogPost.find(params[:id])
    if blog_post.destroy
      flash[:notice] = "Successfully deleted."
    else
      flash[:alert] = "Could not delete."
    end
    redirect_to :back
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title, :body, :approved, :published_at)
  end

end
