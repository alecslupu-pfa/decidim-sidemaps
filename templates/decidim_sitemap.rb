# frozen_string_literal: true

require "sitemap_generator"

Decidim::Organization.find_each do |organization|
  SitemapGenerator::Sitemap.default_host = "https://#{organization.host}"
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{organization.reference_prefix}"

  SitemapGenerator::Sitemap.compress = false

  SitemapGenerator::Sitemap.create do
    Decidim::Sitemaps::Generator.new(organization: organization, sitemap: self).generate_sitemap
  end
end
