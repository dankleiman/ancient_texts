class AddBlogPosts < ActiveRecord::Migration
  def change
     create_table :blog_posts do |t|
      t.integer :post_author_id
      t.string :title
      t.text :body
      t.boolean :approved, default: false
      t.date :published_at
      t.string :slug

      t.timestamps
    end
  end
end
