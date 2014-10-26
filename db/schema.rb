ActiveRecord::Schema.define(version: 20141019192726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: true do |t|
    t.string "full_name"
    t.string "first_name"
    t.string "last_name"
  end

  create_table "books", force: true do |t|
    t.integer "author_id"
    t.string  "title"
    t.text    "content"
    t.integer "gutenberg_id"
  end

  create_table "sections", force: true do |t|
    t.integer "book_id"
    t.text    "content"
    t.integer "position"
  end

end
