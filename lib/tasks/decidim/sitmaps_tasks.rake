# frozen_string_literal: true

require "rake"

Rake::Task["sitemap:install"].clear

task "sitemap:install" do
  Decidim::Sitemaps::Utilities.install_sitemap_rb(verbose:)
end
