require 'acts-as-taggable-on'
require "kaminari"

module PiccoBlog

  class << self
    mattr_accessor :author_class, :include_comments, :include_share_bar
    mattr_accessor :posts_per_page, :layout, :active_states, :hidden_states

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

  def self.setup(&block)
    yield self
  end

  class Engine < ::Rails::Engine
    isolate_namespace PiccoBlog
  end
end
