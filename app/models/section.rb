class Section < ActiveRecord::Base
  belongs_to :book
  has_many :blog_posts
  self.per_page = 1
end
