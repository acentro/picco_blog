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
        @post = post_scope.friendly.find(params[:id])
      end

      # Hidden posts must not be readable at their public URL. Every action
      # other than show has already passed authenticate_user!, so those get
      # the full scope; show is public and sees visible posts only, unless
      # the viewer is an admin previewing a draft.
      #
      # This deliberately uses picco_blog_current_user rather than the
      # authenticate proc, because that proc may perform its own redirect
      # (Devise) and must not be invoked on a public page.
      def post_scope
        return Post.all unless action_name == "show"
        picco_blog_current_user.try(:admin?) ? Post.all : Post.visible
      end

      def set_recent_posts
        @recent_posts = Post.visible.last(PiccoBlog.recent_posts).reverse;
      end

      def set_tags_all
        @available_tags = ActsAsTaggableOn::Tagging.includes(:tag).where(context: 'tags').collect { |tagging| "#{tagging.tag.name}" }.uniq
      end

      # Exposed to views so the engine's own templates never call the host
      # app's current_user directly -- that helper may not exist.
      helper_method :picco_blog_current_user

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
          # The proc may either perform its own redirect (e.g. Devise's
          # authenticate_user!) or return a boolean. Deny unless it did one
          # or the other -- returning false must not fall through as success.
          authorized = instance_exec(&PiccoBlog.authenticate_proc)
          redirect_to root_url unless performed? || authorized
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
