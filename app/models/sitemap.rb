class Sitemap < ActiveRecord::Base
  mount_uploader :sitemap, SitemapUploader
end
