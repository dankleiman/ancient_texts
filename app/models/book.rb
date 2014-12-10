class Book < ActiveRecord::Base
  include FriendlyId
  mount_uploader :content_text, BookContentUploader
  friendly_id :author_and_title, use: [:slugged, :finders]
  after_create :create_from_txt
  belongs_to :author
  has_many :sections, dependent: :destroy
  has_many :blog_posts, through: :sections
  has_one :item
  scope :approved, -> { where approved: true }
  scope :pending, -> { where approved: false }
  scope :with_cover, -> {joins(:item).where('items.id IS NOT NULL').uniq}
  scope :with_recent_posts, ->{joins(:blog_posts).where('blog_posts.published_at < ?', Date.today - 30).uniq}

  def author_and_title
    "#{author.full_name}, #{title}"
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

  def create_pdf!
    book_title = "#{self.title} by #{self.author.full_name}"
    book_content = self.content
    # path =
    # create and upload to s3 folder. need carrierwave attachement?
    Prawn::Document.generate("#{self.title}_by_#{self.author.full_name}.pdf") do
      text book_title

      start_new_page

      text book_content

    end
  end

  private

  def create_from_txt
    text_file = self.content_text.file.path
    text = File.read(text_file)
    book_number = text_file.match(/pg(.*).txt/)[1]
    self.update_attributes(content: text, gutenberg_id: book_number.to_i)
    self.regenerate_sections!
  end
end
