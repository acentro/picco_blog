class AddExcerptToPiccoBlogPosts < ActiveRecord::Migration
  def change
    add_column :picco_blog_posts, :excerpt, :string
  end
end
