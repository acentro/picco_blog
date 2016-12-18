class ChangePiccoBlogPostsExcerptToText < ActiveRecord::Migration
  def change
    change_column :picco_blog_posts, :excerpt, :text
  end
end
