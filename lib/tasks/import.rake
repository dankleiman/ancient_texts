namespace :books do
  desc "import books"
  task import: :environment do
    # want to be able to specific an array of book IDs in the cache and create the objects for them

    # find text file in cache folder
      # search cache for folder with book ID
      # from rdf file, extract text file and save locally for the import...or make source html
    Book.create_from_txt!(ENV['TEXT_FILE'])
  end

  desc "generate sections"
  task generate_sections: :environment do
    # for each book that hasn't been split into sections
    Book.all.select { |book| book.sections.empty? }.each do |book|
      # divide book content into sections
    end
  end
end
