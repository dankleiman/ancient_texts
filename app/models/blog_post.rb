class BlogPost < ActiveRecord::Base
  include FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  belongs_to :post_author
  belongs_to :section
  self.per_page = 5

  def self.approved
    BlogPost.where(approved: true)
  end

  def self.published
    BlogPost.approved.where('published_at <= ?', Date.today)
  end

  def approved?
    self.approved ? 'Yes' : 'No'
  end

  def self.generate_blog_post!
    post_section = Section.all.sample
    post_title = "#{post_section.book.author.full_name}, #{post_section.book.title}, SECTION: #{post_section.position} "
    if BlogPost.find_by(section: post_section)
      BlogPost.generate_blog_post!
    else
      blog_post = BlogPost.create!(title: post_title, post_author_id: 1, approved: false, section: post_section, published_at: (BlogPost.last.published_at + 1) )
      puts "CREATING BLOG POST FROM #{post_title}"
      line_count = 0
      post_section.content.each_line do |line|
        line_count += 1
      end
      seed = rand(0..(line_count-20))
      seed_iterator = seed
      post_body = ''
      line_to_record = 0
      post_section.content.each_line do |line|
        if line_to_record == seed_iterator
          post_body += line
          seed_iterator += 1 unless seed_iterator > (seed + 20)
        end
        line_to_record += 1
      end
      blog_post.update_attributes(body: post_body)
    end
  end

  def preview
    line_count = 1
    preview = ''
    self.body.each_line do |line|
      preview += line unless line_count > 10
      line_count += 1
    end
    preview
  end
end
