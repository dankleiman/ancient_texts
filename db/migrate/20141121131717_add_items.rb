class AddItems < ActiveRecord::Migration
  def change
    remove_attachment :books, :cover
    remove_column :books, :asin

     create_table :items do |t|
      t.string :title
      t.string :image_url
      t.string :detail_page_url
      t.integer :book_id

      t.timestamps
    end
  end
end
