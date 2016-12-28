class AddMembersOnlyFlagToPiccoBlogPosts < ActiveRecord::Migration
  def change
    add_column :picco_blog_posts, :members_only, :boolean, default: false
    add_index :picco_blog_posts, :members_only
  end
end
