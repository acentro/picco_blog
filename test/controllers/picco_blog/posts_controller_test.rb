require 'test_helper'

module PiccoBlog
  class PostsControllerTest < ActionController::TestCase
    # Stands in for the host app's user. The engine only ever asks for #id and
    # #admin?, so this is the whole contract.
    AdminUser = Struct.new(:id) do
      def admin?
        true
      end
    end

    setup do
      @post = picco_blog_posts(:one)
      @routes = Engine.routes

      # The write actions sit behind authenticate_user!, so tests have to
      # supply an authenticated admin or every one of them redirects.
      PiccoBlog.current_user_proc = proc { AdminUser.new(1) }
      PiccoBlog.authenticate_proc = proc { true }
    end

    teardown do
      PiccoBlog.current_user_proc = nil
      PiccoBlog.authenticate_proc = nil
    end

    test "should get index" do
      get :index
      assert_response :success
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create post" do
      assert_difference('Post.count') do
        post :create, params: { post: { text: @post.text, title: "A Brand New Post", state: "visible" } }
      end

      assert_redirected_to post_path(Post.order(:id).last)
    end

    test "should show post" do
      get :show, params: { id: @post.to_param }
      assert_response :success
    end

    test "should get edit" do
      get :edit, params: { id: @post.to_param }
      assert_response :success
    end

    test "should update post" do
      patch :update, params: { id: @post.to_param, post: { text: @post.text, title: @post.title } }
      assert_redirected_to post_path(@post.reload)
    end

    test "should destroy post" do
      assert_difference('Post.count', -1) do
        delete :destroy, params: { id: @post.to_param }
      end

      assert_redirected_to posts_path
    end

    test "should not show a hidden post to an anonymous visitor" do
      PiccoBlog.current_user_proc = nil
      PiccoBlog.authenticate_proc = nil
      @post.hidden!

      assert_raises(ActiveRecord::RecordNotFound) do
        get :show, params: { id: @post.to_param }
      end
    end

    test "should deny a write action when authenticate_proc returns false" do
      PiccoBlog.authenticate_proc = proc { false }

      get :new
      assert_redirected_to root_path
    end
  end
end
