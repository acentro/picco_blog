module PiccoBlog
  module Generators

    class ViewsGenerator < Rails::Generators::Base
      desc "Copies PiccoBlog views to your application."

      include Thor::Actions

      source_root File.expand_path('../../../../../app/views', __FILE__)

      # Copy all of the views from the picco_blog/app/views/picco_blog to
      # app/views/picco_blog
      def copy_views
        directory 'picco_blog', 'app/views/picco_blog'
      end

    end
  end
end