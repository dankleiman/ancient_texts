class AddBookIdToBlogPost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :section_id, :integer
  end
end
