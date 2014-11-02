namespace :blog_post do
  desc "generate new blog post"
  task generate: :environment do
    new_posts = ENV['NEW_POSTS']
    if new_posts.nil?
     BlogPost.generate_blog_post!
    else
      new_posts.to_i.times do
        BlogPost.generate_blog_post!
      end
    end
  end
end
