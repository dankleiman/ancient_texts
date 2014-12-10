class BookContentUploader < CarrierWave::Uploader::Base
  storage :fog
  def store_dir
    "uploads/books"
  end
end
