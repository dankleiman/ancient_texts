class AddAttachmentCoverToBooks < ActiveRecord::Migration
  def self.up
    change_table :books do |t|
      t.attachment :cover
      t.string :asin
    end
  end

  def self.down
    remove_attachment :books, :cover
    remove_column :books, :asin
  end
end
