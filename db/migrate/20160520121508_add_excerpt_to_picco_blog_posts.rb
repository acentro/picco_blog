if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class AddExcerptToPiccoBlogPosts < ActiveRecord::Migration[4.2]; end
else
  class AddExcerptToPiccoBlogPosts < ActiveRecord::Migration; end
end

AddExcerptToPiccoBlogPosts.class_eval do
  def change
    add_column :picco_blog_posts, :excerpt, :string
  end
end
