class Section < ActiveRecord::Base
  belongs_to :book
  self.per_page = 1
end
