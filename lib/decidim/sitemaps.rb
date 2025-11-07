# frozen_string_literal: true

require "sitemap_generator"
require "decidim/sitemaps/engine"

module Decidim
  # This namespace holds the logic of the `Sitemaps`.
  module Sitemaps
    include ActiveSupport::Configurable

    autoload :Utilities, "decidim/sitemaps/utilities"
    autoload :Generator, "decidim/sitemaps/generator"
    autoload :ManifestRegistry, "decidim/sitemaps/manifest_registry"
    autoload :ParticipatorySpaceManifest, "decidim/sitemaps/participatory_space_manifest"
    autoload :ComponentManifest, "decidim/sitemaps/component_manifest"

    config_accessor :batch_size do
      100
    end

    config_accessor :static_pages do
      { enabled: true, changefreq: "daily", priority: 0.5 }
    end

    config_accessor :participatory_processes do
      { enabled: true, changefreq: "daily", priority: 0.5, scopes: [:public_spaces] }
    end

    config_accessor :assemblies do
      { enabled: true, changefreq: "daily", priority: 0.5, scopes: [:public_spaces] }
    end

    config_accessor :conferences do
      { enabled: true, changefreq: "daily", priority: 0.5, scopes: [:public_spaces] }
    end

    config_accessor :initiatives do
      { enabled: true, changefreq: "daily", priority: 0.5, scopes: [:public_spaces] }
    end

    def self.register_participatory_space(name, &)
      participatory_space_registry.register(name, &)
    end

    def self.participatory_space_registry
      @participatory_space_registry ||= Decidim::Sitemaps::ManifestRegistry.new(:participatory_spaces)
    end
  end
end
