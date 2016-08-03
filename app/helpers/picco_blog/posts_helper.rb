module PiccoBlog
  module PostsHelper

    def created_date_display(post)
      post.created_at.strftime("%m/%d/%Y")
    end

    def post_preview(post)
      preview = ""
      unless nil_or_empty(post.excerpt)
        preview = post.excerpt
      else
        preview = truncate(post.text, length: 250)
      end
      
      preview.html_safe + " " + link_to("Continue Reading", post_path(post))
    end

    def nil_or_empty(str)
      str.to_s.nil? || str.to_s.empty?
    end

  end
end
