require 'redcarpet'

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
        # preview = truncate(post.text, length: 250)
        preview = truncate( strip_tags( markdown(post.text) ), length: 250)
      end
      
      preview.html_safe + " " + link_to("Continue Reading", post_path(post))
    end

    def nil_or_empty(str)
      str.to_s.nil? || str.to_s.empty?
    end

    def markdown(text)
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)

      options = {
        autolink: true,
        no_intra_emphasis: true,
        disable_indented_code_blocks: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true
      }

      Redcarpet::Markdown.new(renderer, options).render(text).html_safe
    end

  end
end
