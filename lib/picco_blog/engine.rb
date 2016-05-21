require 'acts-as-taggable-on'
require "kaminari"
require "friendly_id"

module PiccoBlog

  class << self
    mattr_accessor :author_class, :include_comments, :include_share_bar, :recent_posts
    mattr_accessor :posts_per_page, :layout, :active_states, :hidden_states
    mattr_accessor :post_tagging, :post_category_whitelist

    # def self.author_class
    #   @@author_class.constantize
    # end
  end

  self.include_comments = ""
  self.include_share_bar = ""
  self.posts_per_page = ""
  self.layout = ""
  self.active_states = ""
  self.hidden_states = ""
  self.recent_posts = ""
  self.post_tagging = ""
  self.post_category_whitelist = ""

  def self.setup(&block)
    yield self
  end

  class Engine < ::Rails::Engine
    isolate_namespace PiccoBlog

    # initializer "picco_blog.assets.precompile" do |app|
    #   app.config.assets.precompile += %w(posts.css posts.js)
    # end
  end
end
