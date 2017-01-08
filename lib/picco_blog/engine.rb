require 'acts-as-taggable-on'
require "kaminari"
require "friendly_id"

module PiccoBlog

  class << self
    mattr_accessor :author_class, :include_comments, :include_share_bar, :recent_posts
    mattr_accessor :posts_per_page, :layout, :post_tagging, :members_only, :members_only_method 
    mattr_accessor :current_user, :authenticate
  end

  self.include_comments = ""
  self.include_share_bar = ""
  self.posts_per_page = ""
  self.layout = ""
  self.recent_posts = ""
  self.post_tagging = ""
  self.members_only = ""
  self.members_only_method = ""
  self.current_user = ""
  self.authenticate = ""

  def self.setup(&block)
    yield self
  end

  class Engine < ::Rails::Engine
    isolate_namespace PiccoBlog
    config.to_prepare do
      # Make the implementing application's helpers available to the engine.
      # This is required for the overriding of engine views and helpers to work correctly.
      PiccoBlog::ApplicationController.helper Rails.application.helpers
    end
  end
end
