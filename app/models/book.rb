class Book < ActiveRecord::Base
  belongs_to :author
  has_many :sections, dependent: :destroy

  def self.create_from_txt!(text_file)
    # expects text file with book number in title
    # grab title, author, and content for book
    # text_file = "/Users/dankleiman/Downloads/pg#{book_number}.txt"
    start = "*** START OF TH"
    # start = "Produced by Jonathan Ingram"
    ending = "End of the Project Gutenberg"
    # ending = "***END OF THE PROJECT GUTENBERG"
    text = ""
    book_number = text_file.match(/pg(.*).txt/)[1]
    capture = false
    puts "Opening source file: #{text_file}"
    puts start
    @title = ''
    @author = ''
    capturing = 0
    File.open(text_file).each do |line|
      @title = line.split("Title: ").last if line.start_with?("Title:")
      @author = line.split("Author: ").last if line.start_with?("Author:")
      if line.start_with?(start)
        @first_line = line
        capture = true
        capturing += 1
      end
      if capture && capturing == 1
        puts "Capturing: #{line}"
        text += line
      end
      if line.start_with?(ending)
        capture = false
        @last_line = line
      end
    end
    text.slice!(@first_line)
    text.slice!(@last_line)
    text.strip!

    # save book and author info
    Book.transaction do
      begin
        author = Author.find_or_create_by(full_name: @author.strip)
        book = Book.find_or_create_by(title: @title.strip)
        book.update_attributes(author: author, content: text, gutenberg_id: book_number.to_i)
        puts "Created #{book.title} by #{book.author.full_name}"
      rescue => e
        raise e.message
      end
    end
  end
end
