# frozen_string_literal: true

module Decidim
  module Sitemaps
    class Generator
      attr_reader :organization, :sitemap

      def initialize(organization:, sitemap:)
        @organization = organization
        @sitemap = sitemap
      end

      def generate_sitemap
        add_pages_to_sitemap
      end

      protected

      def add_pages_to_sitemap
        return [] unless Decidim::Sitemaps.static_pages.fetch(:enabled, true)

        organization.static_pages_accessible_for(nil).find_each(batch_size:) do |page|
          sitemap.add Decidim::Core::Engine.routes.url_helpers.page_url(page, host: organization.host),
                      changefreq: Decidim::Sitemaps.static_pages.fetch(:changefreq, "daily"),
                      priority: Decidim::Sitemaps.static_pages.fetch(:priority, 0.5),
                      lastmod: page.updated_at,
                      alternates: alternate_pages(page)
        end
      end

      delegate :batch_size, to: Decidim::Sitemaps

      def alternate_locales
        organization.available_locales.excluding(organization.default_locale)
      end

      private

      def alternate_pages(page)
        alternate_locales.map do |locale|
          {
            href: Decidim::Core::Engine.routes.url_helpers.page_url(page, locale:, host: organization.host),
            lang: locale
          }
        end
      end
    end
  end
end
