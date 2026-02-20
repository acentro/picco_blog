module PiccoBlog
  class PostsController < ApplicationController
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :set_recent_posts, only: [:index, :show]
    before_action :set_tags_all, except: [:create, :update, :destroy]
    before_action :authenticate_user!, except: [:index, :show]

    # GET /posts
    def index
      if params[:tag].present?
        @posts = Post.visible.tagged_with(params[:tag]).order('id desc')
      elsif params[:search].present?
        @posts = Post.visible.search(params[:search]).order("id desc")
      else
        @posts = Post.visible.order('id desc')
      end

      @posts = @posts.page params[:page]
      @title = "Blog"
    end

    def admin_list
      @posts = Post.all.order('id desc')
      @posts = @posts.page params[:page]
    end

    # GET /posts/1
    def show
      if request.path != post_path(@post)
        redirect_to @post, status: :moved_permanently
      end
      
      @title = @post.title
      @meta_description = @post.excerpt.truncate(300).strip
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
        @recent_posts = Post.visible.last(PiccoBlog.recent_posts).reverse;
      end

      def set_tags_all
        @available_tags = ActsAsTaggableOn::Tagging.includes(:tag).where(context: 'tags').collect { |tagging| "#{tagging.tag.name}" }.uniq
      end

      def picco_blog_current_user
        if PiccoBlog.current_user_proc
          instance_exec(&PiccoBlog.current_user_proc)
        elsif PiccoBlog.current_user.present?
          # DEPRECATED: String-based config. Use current_user_proc instead.
          ActiveSupport::Deprecation.warn(
            "PiccoBlog.current_user (string) is deprecated. Use PiccoBlog.current_user_proc = proc { current_user } instead."
          )
          eval(PiccoBlog.current_user)
        end
      end

      def authenticate_user!
        if PiccoBlog.authenticate_proc
          instance_exec(&PiccoBlog.authenticate_proc)
        elsif PiccoBlog.current_user.present? && PiccoBlog.authenticate.present?
          # DEPRECATED: String-based eval config. Use authenticate_proc instead.
          ActiveSupport::Deprecation.warn(
            "PiccoBlog.authenticate (string) is deprecated. Use PiccoBlog.authenticate_proc = proc { authenticate_user! } instead."
          )
          redirect_to root_url unless eval(PiccoBlog.current_user).send(PiccoBlog.authenticate)
        else
          redirect_to root_url
        end
      end

      # Only allow a trusted parameter "white list" through.
      def post_params
        params.require(:post).permit(:title, :text, :author_id, :tag_list, :excerpt, :state, :members_only, :featured_image)
      end
  end
end
