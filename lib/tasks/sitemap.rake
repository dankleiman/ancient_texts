namespace :sitemap do
  desc "Generate dynamic sitemap then push to S3"
  task :update => :environment do
      Rake::Task["sitemap:generate"].execute
      Sitemap.create!(sitemap: File.open(Rails.root.join('tmp','sitemaps','sitemap.xml')))
      # s3 = AWS::S3.new(access_key_id: ENV['AWS_ACCESS_KEY'],secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
      # s3.buckets[ENV['S3_BUCKET']].objects['sitemap.xml'].write(data: File.open(Rails.root.join('tmp','sitemaps','sitemap.xml')), acl: :public_read)
  end
end
