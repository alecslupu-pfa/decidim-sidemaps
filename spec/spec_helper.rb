# frozen_string_literal: true

require "decidim/dev"

ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path = File.expand_path(File.join("spec", "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"

def clean_sitemap_files_from_rails_app
  SitemapGenerator.app.root.join("public").rmtree
  SitemapGenerator.app.root.join("public").mkpath
end
