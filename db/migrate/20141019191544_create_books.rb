class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :author_id
      t.string :title
      t.text :content
      t.integer :gutenberg_id
    end
  end
end
