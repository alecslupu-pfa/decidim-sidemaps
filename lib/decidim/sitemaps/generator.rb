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
        add_pages
        add_spaces
      end

      protected

      def add_spaces
        Decidim.participatory_space_manifests.flat_map do |manifest|
          registry = Decidim::Sitemaps.participatory_space_registry.find(manifest.name)

          next if registry.blank?

          settings = Decidim::Sitemaps.send(manifest.name)
          scopes = settings.fetch(:scopes, [:public_spaces])

          next unless settings.fetch(:enabled, true)

          # Chain the scope methods by using reduce
          collection = scopes.reduce(registry.model_class) { |relation, scope| relation.send(scope) }

          collection.each do |process|
            sitemap.add registry.engine_route(process),
                        changefreq: settings.fetch(:changefreq, "daily"),
                        priority: settings.fetch(:priority, 0.5),
                        lastmod: process.updated_at, alternates: alternate_process_routes(registry, process)

            add_component_to_sitemap process:
          end
        end
      end

      def add_component_to_sitemap(process:)
        return unless process.respond_to?(:components)

        process.components.published.each do |component|
          registry = Decidim::Sitemaps.find_component_manifest(component.manifest.name)

          next if registry.blank?

          settings = Decidim::Sitemaps.send(component.manifest.name)
          scopes = settings.fetch(:scopes, [:published])

          next unless settings.fetch(:enabled, true)

          # Chain the scope methods by using reduce
          collection = scopes.reduce(registry.model_class) { |relation, scope| relation.send(scope) }

          collection.where(component:).find_each(batch_size:) do |resource|
            sitemap.add registry.resource_route(resource),
                        changefreq: settings.fetch(:changefreq, "daily"),
                        priority: settings.fetch(:priority, 0.5),
                        lastmod: resource.updated_at,
                        alternates: alternates_resource_routes(registry, resource)
          end
        end
      end

      def add_pages
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

      def alternate_process_routes(registry, process)
        alternate_locales.map do |locale|
          {
            href: registry.engine_route(process, params: { locale: }),
            lang: locale
          }
        end
      end

      def alternates_resource_routes(registry, resource)
        alternate_locales.map do |locale|
          {
            href: registry.resource_route(resource, params: { locale: }),
            lang: locale
          }
        end
      end
    end
  end
end
