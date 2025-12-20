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

    config_accessor :blogs do
      { enabled: true, changefreq: "daily", priority: 0.5, scopes: [:published, :not_hidden] }
    end

    config_accessor :meetings do
      { enabled: true, changefreq: "daily", priority: 0.5, scopes: [:published, :not_hidden, :not_withdrawn, :visible] }
    end

    config_accessor :proposals do
      { enabled: true, changefreq: "daily", priority: 0.5, scopes: [:published, :not_hidden, :not_withdrawn] }
    end

    config_accessor :debates do
      { enabled: true, changefreq: "daily", priority: 0.5, scopes: [:open, :not_hidden] }
    end

    config_accessor :sortitions do
      { enabled: false, changefreq: "daily", priority: 0.5, scopes: [:active] }
    end

    #
    # config_accessor :pages do
    #   { enabled: true, changefreq: "daily", priority: 0.5 }
    # end
    #
    # config_accessor :surveys do
    #   { enabled: false }
    # end

    config_accessor :budgets do
      { enabled: false, changefreq: "daily", priority: 0.5, scopes: [ :all ] }
    end

    # config_accessor :elections do
    #   { enabled: false, changefreq: "daily", priority: 0.5 }
    # end

    #
    # config_accessor :accountability do
    #   { enabled: true, changefreq: "daily", priority: 0.5 }
    # end

    def self.register_participatory_space(name, &)
      participatory_space_registry.register(name, &)
    end

    def self.participatory_space_registry
      @participatory_space_registry ||= Decidim::Sitemaps::ManifestRegistry.new(:participatory_spaces)
    end

    def self.find_component_manifest(name)
      component_registry.find(name.to_sym)
    end

    # Public: Stores the registry of components
    def self.component_registry
      @component_registry ||= Decidim::Sitemaps::ManifestRegistry.new(:components)
    end

    def self.register_component(name, &)
      component_registry.register(name, &)
    end
  end
end
