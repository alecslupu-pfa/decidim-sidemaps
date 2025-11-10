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

      delegate :batch_size, to: Decidim::Sitemaps
      delegate :host, to: :organization

      def add_spaces
        Decidim.participatory_space_manifests.flat_map do |manifest|
          manifest_name = manifest.name
          registry = Decidim::Sitemaps.participatory_space_registry.find(manifest_name)

          add_resource_to_sitemap registry:,
                                  manifest_name:,
                                  default_scope: [:public_spaces],
                                  callback: :add_component_to_sitemap
        end
      end

      def add_component_to_sitemap(process)
        return unless process.respond_to?(:components)

        process.components.published.each do |component|
          manifest_name = component.manifest.name
          registry = Decidim::Sitemaps.find_component_manifest(manifest_name)

          add_resource_to_sitemap registry:,
                                  manifest_name:,
                                  default_scope: [:published],
                                  constraints: { component: }
        end
      end

      def add_resource_to_sitemap(registry:, manifest_name:, default_scope:, callback: nil, constraints: {})
        return if registry.blank?

        settings = Decidim::Sitemaps.send(manifest_name)
        scopes = settings.fetch(:scopes, default_scope)

        return unless settings.fetch(:enabled, true)

        # Chain the scope methods by using reduce
        collection = scopes.reduce(registry.model_class) { |relation, scope| relation.send(scope) }
        collection = collection.where(**constraints) if constraints.present?

        collection.find_each(batch_size:) do |resource|
          sitemap.add registry.resource_route(resource, host:),
                      changefreq: settings.fetch(:changefreq, "daily"),
                      priority: settings.fetch(:priority, 0.5),
                      lastmod: resource.updated_at,
                      alternates: alternates_resource_routes(registry, resource)

          send(callback, resource) if callback.present?
        end
      end

      def add_pages
        manifest_name = :static_pages
        settings = Decidim::Sitemaps.send(manifest_name)
        return [] unless settings.fetch(:enabled, true)

        organization.static_pages_accessible_for(nil).find_each(batch_size:) do |page|
          sitemap.add Decidim::Core::Engine.routes.url_helpers.page_url(page, host: organization.host),
                      changefreq: settings.fetch(:changefreq, "daily"),
                      priority: settings.fetch(:priority, 0.5),
                      lastmod: page.updated_at,
                      alternates: alternate_pages(page)
        end
      end

      def alternate_locales
        organization.available_locales.excluding(organization.default_locale)
      end

      private

      def alternate_pages(page)
        alternate_locales.map do |locale|
          {
            href: Decidim::Core::Engine.routes.url_helpers.page_url(page, locale:, host:),
            lang: locale
          }
        end
      end

      def alternates_resource_routes(registry, resource)
        alternate_locales.map do |locale|
          {
            href: registry.resource_route(resource, host:, params: { locale: }),
            lang: locale
          }
        end
      end
    end
  end
end
