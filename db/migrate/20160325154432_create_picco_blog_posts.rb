class CreatePiccoBlogPosts < ActiveRecord::Migration
  def change
    create_table :picco_blog_posts do |t|
      t.string :title
      t.text :text

      t.timestamps null: false
    end
  end
end
