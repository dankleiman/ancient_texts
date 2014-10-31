class BlogPost < ActiveRecord::Base
  include FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  belongs_to :post_author

  def self.approved
    BlogPost.where(approved: true)
  end



end
