namespace :books do
  desc "import books"
  task import: :environment do
    Book.create_from_txt!(ENV['TEXT_FILE'])
  end

  desc "generate sections"
  task generate_sections: :environment do
    Book.transaction do
      begin
        # for each book that hasn't been split into sections
        Book.all.select { |book| book.sections.empty? }.each do |book|
          section = book.sections.new
          position = 1
          section.position = position
          section.content = ''
          char_count = 0
          book.content.each_line("\r\n") do |line|
            char_count += line.length
            if char_count < 30000
              if position > book.content.length / 30000
                section.save!
                section.update_attributes(content: section.content += line)
              else
              section.content += line
              end
            else
              section.save!
              puts "CREATED SECTION #{position}"
              position += 1
              section = book.sections.new
              section.position = position
              section.content = ''
              section.content += line
              char_count = line.length
            end
          end
        end
      rescue => e
        raise e.message
      end
    end
  end
end
