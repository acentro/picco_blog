if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class AddAuthorIdToPiccoBlogPosts < ActiveRecord::Migration[4.2]; end
else
  class AddAuthorIdToPiccoBlogPosts < ActiveRecord::Migration; end
end

AddAuthorIdToPiccoBlogPosts.class_eval do
  def change
    add_column :picco_blog_posts, :author_id, :integer
    add_index :picco_blog_posts, :author_id
  end
end
