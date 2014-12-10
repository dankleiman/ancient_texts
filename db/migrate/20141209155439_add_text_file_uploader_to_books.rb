class AddTextFileUploaderToBooks < ActiveRecord::Migration
  def change
    add_column :books, :content_text, :string
  end
end
