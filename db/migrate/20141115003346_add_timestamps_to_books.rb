class AddTimestampsToBooks < ActiveRecord::Migration
  def up
    change_table :books do |t|
      t.timestamps
    end

    Book.all.each do |book|
      book.update_attribute(:created_at, DateTime.now)
    end
  end
  def down
    remove_column :books, :created_at, :datetime
    remove_column :books, :updated_at, :datetime
  end
end
