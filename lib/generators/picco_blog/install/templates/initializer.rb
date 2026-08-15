PiccoBlog.setup do |config|

  # override this with the user model that will be tied to each blog post
  # defaults to User model
  config.author_class = "User"

  # Will your blog have member only posts? 
  config.members_only = false

  # If true, override this with the method name on the member class
  # method name defaults to "members_only" and should return boolean (true/false)
  config.members_only_method = "members_only"

  # How the engine finds the logged in user. Evaluated in the controller,
  # so use proc { } rather than a lambda. Used to decide whether to show
  # admin links and whether a hidden post may be previewed.
  config.current_user_proc = proc { current_user }

  # Guards create, edit, update and delete. The proc may perform its own
  # redirect (like Devise's authenticate_user!) or return a boolean --
  # returning false denies the request. If this is not set, every write
  # action is denied.
  config.authenticate_proc = proc { current_user&.admin? }

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