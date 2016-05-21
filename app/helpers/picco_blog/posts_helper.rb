module PiccoBlog
  module PostsHelper

    def created_date_display(post)
      post.created_at.strftime("%m/%d/%Y")
    end

    def post_preview(post)
      return post.excerpt unless nil_or_empty(post.excerpt)
      truncate(post.text, length: 250)
    end

    def nil_or_empty(str)
      str.to_s.nil? || str.to_s.empty?
    end

  end
end
