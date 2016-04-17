module PiccoBlog
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install PiccoBlog in your application"
      source_root File.expand_path('../templates', __FILE__)

      def create_initializer
        copy_file "initializer.rb", "config/initializers/picco_blog.rb"
      end

      def run_migrations
        rake "picco_blog:install:migrations"
        rake "acts_as_taggable_on_engine:install:migrations"
      end
    end
  end
end
