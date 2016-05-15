class AddSlugToPiccoBlogPosts < ActiveRecord::Migration
  def change
    add_column :picco_blog_posts, :slug, :string
    add_index :picco_blog_posts, :slug
  end
end
