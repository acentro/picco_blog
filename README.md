# PiccoBlog

PiccoBlog is a simple and light weight markdown blog engine for Ruby on Rails (v4.2.4+) applications. 

#### Basic functionality includes:

- Title, body, exceprt
- Featured image
- Tagging
- Pagination
- Member's only flag
- Hidden/Visible state

#### TODO:
- Comments are not fully impemented (ActiveRecord or other)

#### Dependencies:
- [SimpleMDE v1.11.2 Markdown Editor Library](https://simplemde.com)

## Installation

Add this line to your application's Gemfile:
```Ruby
gem 'picco_blog', :git => 'https://github.com/acentro/picco_blog'
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

Add to `routes.rb`
```
mount PiccoBlog::Engine => "/blog"
```

Done!

## Configuation


## Copyright
This project rocks and uses MIT-LICENSE.
