class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :book_id
      t.text :content
      t.integer :position
    end
  end
end
