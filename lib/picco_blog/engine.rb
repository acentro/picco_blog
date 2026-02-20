require 'acts-as-taggable-on'
require "kaminari"
require "friendly_id"

module PiccoBlog

  mattr_accessor :author_class, default: nil
  mattr_accessor :include_comments, default: false
  mattr_accessor :include_share_bar, default: false
  mattr_accessor :recent_posts, default: 5
  mattr_accessor :posts_per_page, default: 10
  mattr_accessor :layout, default: nil
  mattr_accessor :post_tagging, default: false
  mattr_accessor :members_only, default: false
  mattr_accessor :members_only_method, default: nil
  mattr_accessor :current_user, default: nil
  mattr_accessor :authenticate, default: nil

  # New proc-based auth (Phase 3 — replaces eval-based auth)
  mattr_accessor :current_user_proc, default: nil
  mattr_accessor :authenticate_proc, default: nil

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
