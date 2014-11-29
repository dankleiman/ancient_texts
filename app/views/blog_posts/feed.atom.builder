atom_feed do |feed|
  feed.title "Ancient Wisdom Texts"
  feed.updated @blog_posts.maximum(:published_at)

  @blog_posts.each do |post|
    feed.entry post, {published: post.published_at, updated: post.updated_at} do |entry|
      entry.title post.title
      entry.content post.body, type: 'html'
      entry.author "Ancient Wisdom Texts"
      entry.url blog_post_url(post)
      entry.summary post.preview
    end
  end
end
