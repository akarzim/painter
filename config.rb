require 'pry'
require 'slim'
# Slim::Engine.disable_option_validator!

###
# Page options, layouts, aliases and proxies
###
activate :autoprefixer, browsers: ['last 2 versions', 'Explorer >= 8']
activate :directory_indexes
activate :i18n

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

# Build-specific configuration
configure :build do
  activate :favicon_maker, icons: {
    File.join(config.images_dir, '_favicon_base.png') => [
      { icon: 'apple-touch-icon-114x114-precomposed.png' },
      { icon: 'apple-touch-icon-152x152-precomposed.png' },
      { icon: 'apple-touch-icon-72x72-precomposed.png' },
      { icon: 'chrome-touch-icon-192x192.png' },
      { icon: 'favicon-160x160.png' },
      { icon: 'favicon-16x16.png' },
      { icon: 'favicon-196x196.png' },
      { icon: 'favicon-32x32.png' },
      { icon: 'favicon-96x96.png' },
      { icon: 'favicon.ico', size: '64x64,32x32,24x24,16x16' },
      { icon: 'ms-touch-icon-144x144-precomposed.png', size: '144x144' }
    ]
  }

  activate :webp do |webp|
    webp.ignore = %r{^build\/(?!.*#{config.images_dir}\/).*}
    webp.run_before_build = true
    webp.conversion_options = {
      "source/images/tableaux/*.jpg" => { lossless: true, z: 6 }
    }
  end

  activate :imageoptim do |opts|
		opts.manifest = true
    # Compressor worker options
    # individual optimisers can be disabled by passing false instead of a hash
    opts.pngout = false
    opts.svgo = false
  end

  activate :minify_html, remove_input_attributes: false
  activate :minify_css
  activate :minify_javascript
  activate :gzip
  activate :asset_hash

  # activate :sitemap, hostname: app.data.settings.site.url
  set :url_root, app.data.settings.site.url
  activate :search_engine_sitemap

  activate :robots do |opts|
    opts.rules = [{ user_agent: '*', allow: %w(/) }]
    opts.sitemap = File.join(app.data.settings.site.url, 'sitemap.xml')
  end

  # Use this for gh-pages
  # activate :relative_assets
  # set :relative_links, true

  activate :gh_pages do |gh_pages|
    gh_pages.remote = 'git@github.com:akarzim/painter.git'
    gh_pages.branch = 'gh-pages'
  end
end
