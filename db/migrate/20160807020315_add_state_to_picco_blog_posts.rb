class AddStateToPiccoBlogPosts < ActiveRecord::Migration
  def change
    add_column :picco_blog_posts, :state, :integer
    add_index :picco_blog_posts, :state
  end
end
