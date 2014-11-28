namespace :sitemap do
  desc "Generate dynamic sitemap then push to S3"
  task :update => :environment do
      Rake::Task["sitemap:generate"].execute
      Sitemap.create!(sitemap: File.open(Rails.root.join('tmp','sitemaps','sitemap.xml')))
  end
end
