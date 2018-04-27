if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class AddMembersOnlyFlagToPiccoBlogPosts < ActiveRecord::Migration[4.2]; end
else
  class AddMembersOnlyFlagToPiccoBlogPosts < ActiveRecord::Migration; end
end

AddMembersOnlyFlagToPiccoBlogPosts.class_eval do
  def change
    add_column :picco_blog_posts, :members_only, :boolean, default: false
    add_index :picco_blog_posts, :members_only
  end
end
