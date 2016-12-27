PiccoBlog.setup do |config|

  # overwrite this with the user model that will be tied to each blog post
  # defaults to User model
  config.author_class = "User"

  # What kind of comments do you want to add to your blog ? (:active_record or :no)
  # Disqus comments will be added in future
  config.include_comments = :active_record

  # Should there be a share bar on every post ?
  config.include_share_bar = true

  # No. of posts to show per page
  config.posts_per_page = 5

  # Set the layout named here that PiccoBlog::PostsController will use
  config.layout = "application"

  # No. of recent posts to show in blog sidebar
  config.recent_posts = 8

  # How do you want to handle the display of tags? (:list or :cloud)
  config.post_tagging = :list

end