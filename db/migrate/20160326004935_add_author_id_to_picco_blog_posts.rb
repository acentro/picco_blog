class AddAuthorIdToPiccoBlogPosts < ActiveRecord::Migration
  def change
    add_column :picco_blog_posts, :author_id, :integer
    add_index :picco_blog_posts, :author_id
  end
end
