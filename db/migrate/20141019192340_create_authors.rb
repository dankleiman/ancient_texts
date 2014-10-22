class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :full_name
      t.string :first_name
      t.string :last_name
    end
  end
end
