if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class AddStateToPiccoBlogPosts < ActiveRecord::Migration[4.2]; end
else
  class AddStateToPiccoBlogPosts < ActiveRecord::Migration; end
end

AddStateToPiccoBlogPosts.class_eval do
  def change
    add_column :picco_blog_posts, :state, :integer
    add_index :picco_blog_posts, :state
  end
end
