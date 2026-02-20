![PiccoBlog Logo](https://acentrosys.com/piccoblog/piccoblog-b.png)

[![Gem Version](https://badge.fury.io/rb/picco_blog.svg)](https://badge.fury.io/rb/picco_blog)

PiccoBlog is a simple and light weight markdown blog engine for Ruby on Rails (7.1+) applications.

**Requirements:**
- Ruby 3.2+
- Rails 7.1+

#### Basic functionality includes:

- Title, body, excerpt
- Featured image
- Tagging
- Pagination
- Member's only flag
- Hidden/Visible state
- Comments

#### Dependencies:
- [SimpleMDE v1.11.2 Markdown Editor Library](https://simplemde.com)
- jQuery

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'picco_blog'
```

And then execute:
```
$ bundle install
```

Generate the install files (migrations and initializer)
```
$ rails generate picco_blog:install
```

Run migrations
```
$ rake db:migrate
```

If you want to override the default ERB views (most likely you do)
```
$ rails generate picco_blog:views
```

Add to `config/routes.rb`
```ruby
mount PiccoBlog::Engine => "/blog"
```

Include the PiccoBlog Javascript and CSS Assets. Note: jQuery is required to be loaded first!

Add to `assets/javascripts/application.js`
```
//= require picco_blog/application
```

Add to `assets/stylesheets/application.css`
```
 *= require picco_blog/application
```

Done!

## Configuration

#### Initializer
The default initializer was copied to `config/initializers/picco_blog.rb`. Each configurable option is commented in the file.

#### Authentication (proc-based)

Configure authentication using procs in your initializer:

```ruby
PiccoBlog.setup do |config|
  config.author_class = "User"

  # Authentication — use procs (recommended)
  config.current_user_proc = proc { current_user }
  config.authenticate_proc = proc { authenticate_user! }

  # Other options
  config.posts_per_page = 10
  config.include_comments = true
  config.include_share_bar = true
  config.recent_posts = 5
  config.post_tagging = true
  config.layout = "application"  # or nil for engine default
end
```

> **Note:** The old string-based `current_user` and `authenticate` config options are deprecated and will be removed in a future version. Please migrate to the proc-based syntax above.

#### Dependency gems
By default, Dragonfly and Friendly ID gems are utilized. To override these configurations, create `config/initializers/dragonfly.rb` and `config/initializers/friendly_id.rb` initializers.

## Issues
Please use the [issue tracker](https://github.com/acentro/picco_blog/issues) if you have any issues.

## License
MIT License.
