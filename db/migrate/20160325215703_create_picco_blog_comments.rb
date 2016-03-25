class CreatePiccoBlogComments < ActiveRecord::Migration
  def change
    create_table :picco_blog_comments do |t|
      t.integer :post_id
      t.text :text

      t.timestamps null: false
    end
  end
end
