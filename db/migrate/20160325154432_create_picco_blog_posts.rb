if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class CreatePiccoBlogPosts < ActiveRecord::Migration[4.2]; end
else
  class CreatePiccoBlogPosts < ActiveRecord::Migration; end
end

CreatePiccoBlogPosts.class_eval do
  def change
    create_table :picco_blog_posts do |t|
      t.string :title
      t.text :text

      t.timestamps null: false
    end
  end
end
