if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class AddSlugToPiccoBlogPosts < ActiveRecord::Migration[4.2]; end
else
  class AddSlugToPiccoBlogPosts < ActiveRecord::Migration; end
end

AddSlugToPiccoBlogPosts.class_eval do
  def change
    add_column :picco_blog_posts, :slug, :string
    add_index :picco_blog_posts, :slug
  end
end
