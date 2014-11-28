class CreateSitemaps < ActiveRecord::Migration
  def change
    create_table :sitemaps do |t|
      t.string :sitemap
      t.timestamps
    end
  end
end
