class AddFieldsToPiccoBlogComments < ActiveRecord::Migration[7.1]
  def change
    rename_column :picco_blog_comments, :text, :body
    add_column :picco_blog_comments, :author_id, :integer
    add_column :picco_blog_comments, :author_type, :string
    add_column :picco_blog_comments, :approved, :boolean, default: false
  end
end
