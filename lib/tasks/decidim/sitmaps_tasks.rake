# frozen_string_literal: true

require "rake"

namespace :decidim do
  namespace :sitemap do
    desc "Install a default config/decidim_sitemap.rb file"
    task install: ["sitemap:require"] do
      Decidim::Sitemaps::Utilities.install_sitemap_rb(verbose: verbose)
    end
  end
end
Rake::Task["sitemap:install"].enhance(["decidim:sitemap:install"])
