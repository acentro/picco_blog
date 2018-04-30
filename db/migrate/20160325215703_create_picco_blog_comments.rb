if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class CreatePiccoBlogComments < ActiveRecord::Migration[4.2]; end
else
  class CreatePiccoBlogComments < ActiveRecord::Migration; end
end

CreatePiccoBlogComments.class_eval do
  def change
    create_table :picco_blog_comments do |t|
      t.integer :post_id
      t.text :text

      t.timestamps null: false
    end
  end
end
