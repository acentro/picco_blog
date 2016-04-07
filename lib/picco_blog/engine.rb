module PiccoBlog

  class << self
      mattr_accessor :author_class

      def self.author_class
        @@author_class.constantize
      end

      # add default values of more config vars here
      #self.config_example = ""
  end

  def self.setup(&block)
    yield self
  end

  class Engine < ::Rails::Engine
    isolate_namespace PiccoBlog
  end
end
