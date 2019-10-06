require 'redcarpet'
require 'uri'

module PiccoBlog
  module PostsHelper
    include ActsAsTaggableOn::TagsHelper

    def created_date_display(post, format="")
      format = "%m/%d/%Y" if format.blank?
      post.created_at.strftime(format)
    end

    def post_preview(post, continue_link=true, length=250)
      preview = ""
      unless nil_or_empty(post.excerpt)
        preview = strip_tags(markdown(post.excerpt))
      else
        preview = truncate(strip_tags(markdown(post.text)), length: length)
      end

      preview += " " + link_to("Continue Reading", picco_blog.post_path(post)) if continue_link
      preview.html_safe 
    end

    def nil_or_empty(str)
      str.to_s.nil? || str.to_s.empty?
    end

    def markdown(text)
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: false)

      options = {
        autolink: true,
        no_intra_emphasis: true,
        disable_indented_code_blocks: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true,
        tables: true
      }

      Redcarpet::Markdown.new(renderer, options).render(text).html_safe
    end

    def post_title_encode(post)
      URI.encode(post.title) if post
    end

    def post_url_encode(post)
      URI.encode(post_url(post)) if post
    end

    def members_only_check(user)
      user.send(PiccoBlog.members_only_method)
    end

    def linked_tag_list(tag_list)
      "" unless tag_list

      tag_list.map{|tag| link_to tag, tagged_url(:tag => tag) }.join(", ").html_safe
    end

  end
end
