require_dependency "picco_blog/application_controller"

module PiccoBlog
  class PostsController < ApplicationController
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :set_recent_posts, only: [:index, :show]

    # GET /posts
    def index
      if params[:tag]
        @posts = Post.tagged_with(params[:tag]).order('id desc')
      else
        @posts = Post.all.order('id desc')
      end
      #@posts = @posts.order(created_at: :desc).paginate(page:params[:page], per_page: PiccoBlog.posts_per_page )
    end

    # GET /posts/1
    def show
      if request.path != post_path(@post)
        redirect_to @post, status: :moved_permanently
      end
    end

    # GET /posts/new
    def new
      @post = Post.new
    end

    # GET /posts/1/edit
    def edit
    end

    # POST /posts
    def create
      @post = Post.new(post_params)

      if @post.save
        redirect_to @post, notice: 'Post was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /posts/1
    def update
      if @post.update(post_params)
        redirect_to @post, notice: 'Post was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /posts/1
    def destroy
      @post.destroy
      redirect_to posts_url, notice: 'Post was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_post
        @post = Post.friendly.find(params[:id])
      end

      def set_recent_posts
        @recent_posts = Post.last(PiccoBlog.recent_posts).reverse;
      end

      # Only allow a trusted parameter "white list" through.
      def post_params
        params.require(:post).permit(:title, :text, :author_id, :tag_list)
      end
  end
end
