class SitemapUploader < CarrierWave::Uploader::Base
  storage :fog
  def store_dir
    "uploads/#{model.class.to_s.underscore.pluralize}"
  end
end
