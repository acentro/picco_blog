if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class AddFeaturedImageToPiccoBlogPosts < ActiveRecord::Migration[4.2]; end
else
  class AddFeaturedImageToPiccoBlogPosts < ActiveRecord::Migration; end
end

AddFeaturedImageToPiccoBlogPosts.class_eval do
  def change
    add_column :picco_blog_posts, :featured_image_uid,  :string
    add_column :picco_blog_posts, :featured_image_name, :string 
  end
end
