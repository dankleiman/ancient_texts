class Book < ActiveRecord::Base
  include FriendlyId
  friendly_id :author_and_title, use: [:slugged, :finders]
  belongs_to :author
  has_many :sections, dependent: :destroy
  has_many :blog_posts, through: :sections
  has_one :item
  scope :approved, -> { where approved: true }
  scope :pending, -> { where approved: false }
  scope :with_cover, -> {joins(:item).where('items.id IS NOT NULL').uniq}

  def author_and_title
    "#{author.full_name}, #{title}"
  end

  def self.create_from_txt!(text_file)
    # expects text file with book number in title
    # grab title, author, and content for book
    # text_file = "/Users/dankleiman/Downloads/pg#{book_number}.txt"
    text = ""
    book_number = text_file.original_filename.match(/pg(.*).txt/)[1]
    puts "Opening source file: #{text_file.original_filename}"
    @title = ''
    @author = ''
    File.open(text_file.tempfile).each do |line|
      @title = line.split("Title: ").last if line.start_with?("Title:")
      @author = line.split("Author: ").last if line.start_with?("Author:")
      text += line
    end
    text.strip!

    # save book and author info
    Book.transaction do
      begin
        author = Author.find_or_create_by(full_name: @author.strip)
        puts "AUTHOR: #{author.full_name}"
        book = Book.find_or_create_by(title: @title.strip, author: author)
        puts "BOOK: #{book.title}"
        book.update_attributes(content: text, gutenberg_id: book_number.to_i)
        book.regenerate_sections!
        puts "Created #{book.title} by #{book.author.full_name}"
      rescue => e
        raise e.message
      end
    end
  end

  def self.generate_sections
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

  def regenerate_sections!
    Book.transaction do
      begin
        # create a map of current positions and sections
        old_sections = {}
        self.sections.each { |section| old_sections[section.position] = section.id }
        self.sections.destroy_all
        puts "DESTROYING OLD SECTIONS"
        section = self.sections.new
        position = 1
        section.position = position
        section.content = ''
        char_count = 0
        self.content.each_line("\r\n") do |line|
          char_count += line.length
          if char_count < 30000
            if position > self.content.length / 30000
              section.save!
              section.update_attributes(content: section.content += line)
            else
            section.content += line
            end
          else
            section.save!
            position += 1
            section = self.sections.new
            section.position = position
            section.content = ''
            section.content += line
            char_count = line.length
          end
        end
        puts "CREATED #{position} SECTIONS"
        old_sections.each do |position, section_id|
          blog_post = BlogPost.find_by(section_id: section_id)
          blog_post.update_attributes(section_id: self.sections.where(position: position).first.id) unless blog_post.nil?
        end
        puts "UPDATED RELATED BLOG POSTS"
      rescue => e
        raise e.message
      end
    end
  end
end
