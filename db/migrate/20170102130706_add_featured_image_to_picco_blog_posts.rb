class AddFeaturedImageToPiccoBlogPosts < ActiveRecord::Migration
  def change
    add_column :picco_blog_posts, :featured_image_uid,  :string
    add_column :picco_blog_posts, :featured_image_name, :string 
  end
end
