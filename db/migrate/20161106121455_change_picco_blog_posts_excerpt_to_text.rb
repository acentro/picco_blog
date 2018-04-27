if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class ChangePiccoBlogPostsExcerptToText < ActiveRecord::Migration[4.2]; end
else
  class ChangePiccoBlogPostsExcerptToText < ActiveRecord::Migration; end
end

ChangePiccoBlogPostsExcerptToText.class_eval do
  def change
    change_column :picco_blog_posts, :excerpt, :text
  end
end
