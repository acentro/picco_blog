# PiccoBlog Rails 7.1+ Compatibility Audit

**Date:** 2026-02-20  
**Current Version:** 1.4.3  
**Target:** Rails 7.1+ (tested against Rails 7.1.6 and 8.1.2)  
**Ruby:** 3.2.10  
**Status:** ❌ **Hard-blocked** — app fails to load on Rails 7.1+

---

## 1. Gemspec/Dependency Issues

### `picco_blog.gemspec`

| Dependency | Current Spec | Issue | Severity |
|---|---|---|---|
| `rails` | `>= 4.2.4` | Too permissive — resolves to latest (8.x) with no upper bound. Should pin `~> 7.1` for 7.1 compat. | 🟡 Medium |
| `acts-as-taggable-on` | No version constraint | Works on Rails 7.1 (v10+), but needs pinning. | 🟡 Medium |
| `kaminari` | No version constraint | Generally compatible. | 🟢 Low |
| `friendly_id` | `>= 5.1.0` | Works on Rails 7.1 (v5.5+). | 🟢 Low |
| `redcarpet` | No version constraint | Pure C ext, no Rails dependency — fine. | 🟢 Low |
| `dragonfly` | `>= 1.1.1` | Works technically, but Dragonfly is essentially **unmaintained**. Last meaningful release was years ago. Should be replaced with ActiveStorage. | 🔴 High |
| `mime-types` | No version constraint | Fine, but may conflict with `marcel` (Rails 7.1 default). | 🟡 Medium |
| `sqlite3` (dev) | No version constraint | Rails 7.1 requires `sqlite3 >= 1.4`. Needs version pin. | 🟡 Medium |
| `s.test_files` | Uses deprecated accessor | `test_files=` is deprecated in modern RubyGems. Use `spec.files` patterns instead. | 🟡 Medium |

### Missing Dependencies
- **`sprockets-rails`** — Rails 7.1 no longer bundles sprockets by default but PiccoBlog's asset pipeline depends on it.
- **`jquery-rails`** — All JS uses jQuery (`$(document).ready(...)`, `$('textarea...')`, `$.tagit()`) but it's not declared as a dependency.

---

## 2. Deprecated API Usage

### 🔴 CRITICAL — Hard Blocker

**File:** `lib/picco_blog/engine.rb:7-8`
```ruby
class << self
  mattr_accessor :author_class, :include_comments, ...
end
```
**Error:** `TypeError: module attributes should be defined directly on class, not singleton`  
**Why:** Rails 7.1 (ActiveSupport) explicitly prohibits `mattr_accessor` inside `class << self` blocks.  
**Fix:** Move `mattr_accessor` calls to the module body directly (outside `class << self`).

### 🟠 Deprecated Patterns

| File | Line | Issue | Rails Version Removed |
|---|---|---|---|
| `lib/picco_blog/engine.rb:8` | `mattr_accessor` in singleton | Hard error in Rails 7.1+ | 7.1 |
| `app/controllers/picco_blog/posts_controller.rb:1` | `require_dependency` | No-op/removed in Zeitwerk (Rails 7+) | 7.0 |
| `app/controllers/picco_blog/comments_controller.rb:1` | `require_dependency` | Same as above | 7.0 |
| `test/dummy/config/application.rb:22` | `config.active_record.raise_in_transactional_callbacks = true` | Removed in Rails 5.1 — causes error | 5.1 |
| `test/dummy/config/environments/test.rb:11` | `config.cache_classes = true` | Renamed to `config.enable_reloading` in Rails 7.1 | 7.1 (warns) |
| `test/dummy/config/environments/test.rb:17` | `config.serve_static_files = true` | Renamed to `config.public_file_server.enabled` in Rails 5.0 | 5.0 |
| `test/dummy/config/environments/test.rb:18` | `config.static_cache_control` | Renamed to `config.public_file_server.headers` | 5.0 |
| `test/dummy/config/environments/test.rb:26` | `config.action_dispatch.show_exceptions = false` | Changed to `:none` (symbol) in Rails 7.1 | 7.1 |
| `app/helpers/picco_blog/posts_helper.rb:47` | `URI.encode()` | Removed from Ruby 3.0+ stdlib | Ruby 3.0 |
| `app/helpers/picco_blog/posts_helper.rb:51` | `URI.encode()` | Same — use `CGI.escape` or `URI::DEFAULT_PARSER.escape` | Ruby 3.0 |
| `app/views/picco_blog/posts/index.html.erb` | `link_to ... method: :delete` | Requires `rails-ujs` or Turbo — neither is declared as dependency | 7.0 |
| `app/views/picco_blog/posts/edit.html.erb` | `link_to ... method: :delete` | Same | 7.0 |
| `app/views/picco_blog/posts/admin_list.html.erb` | `link_to ... method: :delete` | Same | 7.0 |
| `app/controllers/picco_blog/posts_controller.rb:56` | `eval(PiccoBlog.current_user)` | Security risk — `eval` for auth is dangerous; should use a proc/lambda | All |

---

## 3. Asset Pipeline Issues

### Sprockets Dependency (Not Declared)
PiccoBlog uses the classic Sprockets asset pipeline:
- `app/assets/javascripts/picco_blog/application.js` — uses `//= require` directives
- `app/views/layouts/picco_blog/application.html.erb` — uses `javascript_include_tag` and `stylesheet_link_tag`

Rails 7.1 defaults to **importmaps + propshaft**. Sprockets still works but must be explicitly included.

### jQuery Dependency (Not Declared)
All JavaScript requires jQuery:
- **`app/assets/javascripts/picco_blog/posts.js`** — `$(document).ready(...)`, `$('textarea...')`, `$('.tagit()')`
- **`app/assets/javascripts/picco_blog/tag-it.min.js`** — jQuery UI Tag-it widget
- jQuery is **not listed** in the gemspec or Gemfile

### SimpleMDE
- `simplemde.min.js` and `simplemde.min.css` are **vendored** directly in `app/assets/`
- SimpleMDE is **abandoned** upstream (last update 2016). Consider **EasyMDE** (maintained fork) or a modern editor.

### Tag-it
- `tag-it.min.js` — jQuery UI dependent, vendored
- `jquery.tagit.css` and `tagit.ui-zendesk.css` — vendored stylesheets
- Should be replaced with a modern tagging UI (Tagify, Tom Select, etc.)

### `rails-ujs` / UJS
- Delete links use `method: :delete` and `data: { confirm: ... }` which require `rails-ujs` or `@hotwired/turbo`
- Neither is included

---

## 4. Model Issues

### `PiccoBlog::Post` (`app/models/picco_blog/post.rb`)

| Issue | Detail |
|---|---|
| `dragonfly_accessor :featured_image` | Dragonfly integration — see §7 |
| `validates_property :format, of: :featured_image` | Dragonfly-specific validation |
| `featured_image_changed?` | Dragonfly method |
| `enum state: [:visible, :hidden]` | Rails 7.1 changed enum syntax. Old positional args still work but deprecated. New: `enum :state, { visible: 0, hidden: 1 }` |
| `PiccoBlog.author_class.constantize.find(author_id)` in `set_author` | Called in `before_validation` — will error if `author_class` is empty string (default) |
| `paginates_per PiccoBlog.posts_per_page` | `posts_per_page` defaults to `""` — kaminari will error on empty string |
| `belongs_to :author` | Rails 7+ requires `belongs_to` associations to be present by default. If `author_id` is nil, validation fails. May need `optional: true`. |

### `Slug` (`app/models/slug.rb`)
- Defined **outside** the `PiccoBlog` namespace — pollutes the host app's namespace
- Uses `update_column` which bypasses callbacks (intentional, but worth noting)

### `PiccoBlog::Comment` (`app/models/picco_blog/comment.rb`)
- Empty model — no validations, no associations declared (missing `belongs_to :post`)

---

## 5. Controller Issues

| File | Issue |
|---|---|
| `posts_controller.rb:1` | `require_dependency` — removed in Zeitwerk |
| `comments_controller.rb:1` | `require_dependency` — removed in Zeitwerk |
| `posts_controller.rb:56` | `eval(PiccoBlog.current_user).send(PiccoBlog.authenticate)` — **`eval` for authentication is a severe security anti-pattern**. Should accept a proc/lambda. |
| `posts_controller.rb` | Uses `before_action` (correct, not `before_filter`) ✅ |
| `application_controller.rb` | `layout PiccoBlog.layout` — layout defaults to `""` which may cause unexpected behavior |

---

## 6. Test Failures

**Tests cannot run at all.** The `mattr_accessor` error in `engine.rb` is a hard blocker that prevents even loading the Rails environment.

```
TypeError: module attributes should be defined directly on class, not singleton
  engine.rb:8:in `singleton class'
```

Additionally, the test dummy app has its own compatibility issues:
- `config.active_record.raise_in_transactional_callbacks = true` — removed in Rails 5.1
- `config.cache_classes`, `config.serve_static_files`, `config.static_cache_control` — all deprecated/renamed
- `config.action_dispatch.show_exceptions = false` — must be `:none` in Rails 7.1

**No test results available** — zero tests could execute.

---

## 7. Dragonfly Deep-Dive

### Integration Depth: **MODERATE** — replaceable but touches multiple layers

#### Configuration
- **`config/initializers/dragonfly.rb`**:
  - Uses `plugin :imagemagick` (requires ImageMagick system dependency)
  - Hardcoded secret key (should use Rails credentials)
  - Custom URL format: `/media/:job/:name`
  - File datastore: `public/system/dragonfly/<env>/`
  - Mounts as Rack middleware: `Rails.application.middleware.use Dragonfly::Middleware`
  - Extends `ActiveRecord::Base` globally with `Dragonfly::Model` and `Dragonfly::Model::Validations`

#### Model Usage (`Post`)
- **`dragonfly_accessor :featured_image`** — adds virtual attributes for image upload
- **DB columns:** `featured_image_uid` (string), `featured_image_name` (string) in `picco_blog_posts` table
- **Validation:** `validates_property :format, of: :featured_image` — Dragonfly-specific validator
- **Conditional:** `featured_image_changed?` — Dragonfly method to check if image was modified

#### View Usage
- **`_form.html.erb`:** `f.object.featured_image_stored?`, `f.object.featured_image.thumb('200x100').url` — thumbnail generation
- **`show.html.erb`:** `@post.featured_image_stored?`, `@post.featured_image.thumb('847x300#').url` — display with crop

#### Migration Path to ActiveStorage
1. Add `has_one_attached :featured_image` to Post model
2. Replace `featured_image_stored?` → `featured_image.attached?`
3. Replace `featured_image.thumb('200x100').url` → `featured_image.variant(resize_to_limit: [200, 100])`
4. Replace `featured_image.thumb('847x300#').url` → `featured_image.variant(resize_to_fill: [847, 300])`
5. Remove `featured_image_uid` and `featured_image_name` columns
6. Write data migration to move files from `public/system/dragonfly/` to ActiveStorage
7. Remove Dragonfly initializer and middleware
8. Remove `dragonfly` and `mime-types` gems

---

## 8. Recommended Migration Path

Ordered from easiest (quick fixes) to hardest (architectural changes):

### Phase 1: Make It Load (1-2 hours)

1. **Fix `mattr_accessor` in engine.rb** — move out of `class << self` block to module body
2. **Remove `require_dependency`** from both controllers — not needed with Zeitwerk
3. **Fix `URI.encode`** → `CGI.escape` in `posts_helper.rb`
4. **Update test dummy app** — fix all deprecated config options

### Phase 2: Dependency Cleanup (2-4 hours)

5. **Pin gem versions** in gemspec: `rails ~> 7.1`, `acts-as-taggable-on ~> 10.0`, `friendly_id ~> 5.5`
6. **Add `sprockets-rails`** as dependency (or migrate to propshaft)
7. **Add `jquery-rails`** as dependency (or plan to remove jQuery)
8. **Update `sqlite3`** dev dependency to `~> 1.4`
9. **Remove `s.test_files`** from gemspec, use `s.files` patterns
10. **Fix enum syntax** — `enum :state, { visible: 0, hidden: 1 }`

### Phase 3: Security & Code Quality (2-4 hours)

11. **Replace `eval()` auth** — accept a proc/lambda for `current_user` and `authenticate`
12. **Fix config defaults** — change empty strings `""` to `nil` for optional configs
13. **Add `belongs_to :post`** to Comment model
14. **Move `Slug` model** into `PiccoBlog` namespace (or remove if FriendlyId handles it)
15. **Remove hardcoded Dragonfly secret** — use `Rails.application.secret_key_base`

### Phase 4: Asset Pipeline Modernization (4-8 hours)

16. **Add `rails-ujs` or Turbo** for delete links / confirmations
17. **Replace SimpleMDE** with EasyMDE (maintained fork) or a modern editor
18. **Replace jQuery Tag-it** with Tagify or similar
19. **Evaluate jQuery removal** — most uses are trivial and replaceable with vanilla JS
20. **Remove Google+ share button** from `_sharebuttons.html.erb` (service shut down 2019)

### Phase 5: Dragonfly → ActiveStorage (8-16 hours)

21. **Add ActiveStorage** to the engine
22. **Migrate Post model** — `has_one_attached :featured_image`
23. **Update views** — new variant/attachment helpers
24. **Write data migration** script for existing installations
25. **Remove Dragonfly** gem, initializer, middleware, and DB columns

### Phase 6: Test Suite (4-8 hours)

26. **Rewrite test dummy app** for Rails 7.1
27. **Add integration tests** for post CRUD, comments, tagging, image upload
28. **Add CI** (GitHub Actions) with Ruby 3.2+ and Rails 7.1+

---

## Summary

| Category | Issues Found | Blockers |
|---|---|---|
| Load/Boot | 1 | ✅ `mattr_accessor` singleton error |
| Deprecated APIs | 12+ | Several hard errors on 7.1 |
| Asset Pipeline | 4 | Missing jQuery, Sprockets, UJS deps |
| Models | 6 | Enum syntax, namespace pollution |
| Controllers | 3 | `eval()` auth, `require_dependency` |
| Tests | N/A | Cannot run — blocked by boot error |
| Dragonfly | Deep but contained | Moderate migration effort |

**Bottom line:** PiccoBlog is frozen at Rails ~4.2–5.x era. The `mattr_accessor` error alone makes it completely non-functional on Rails 7.1+. A significant rewrite is needed, but the codebase is small (~15 files of real code) so a v2.0 is very achievable.
