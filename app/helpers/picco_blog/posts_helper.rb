module PiccoBlog
  module PostsHelper

    def created_date_display(post)
      post.created_at.strftime("%m/%d/%Y")
    end

  end
end
