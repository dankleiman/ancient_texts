# Change this to your host. See the readme at https://github.com/lassebunk/dynamic_sitemaps
# for examples of multiple hosts and folders.
host "www.ancientwisdomtexts.com"

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
  url books_url, last_mod: Time.now, change_freq: "weekly", priority: 0.5
  url authors_url, last_mod: Time.now, change_freq: "weekly", priority: 0.5
  BlogPost.published.each do |post|
    url post, last_mod: post.published_at, priority: 1.0
  end
end

# Ping search engines after sitemap generation:
ping_with "http://#{host}/sitemap.xml"
