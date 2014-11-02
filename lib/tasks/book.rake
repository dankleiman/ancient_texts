namespace :books do
  desc "import books"
  task import: :environment do
    Book.create_from_txt!(ENV['TEXT_FILE'])
  end

  desc "generate sections"
  task generate_sections: :environment do
    Book.generate_sections
  end
end
