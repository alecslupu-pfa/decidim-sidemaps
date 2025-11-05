# frozen_string_literal: true

module Decidim
  module Sitemaps
    class ParticipatorySpaceManifest
      include ActiveModel::Model
      include Decidim::AttributeObject::Model

      attribute :name, Symbol
      attribute :route, Symbol
      attribute :scopes, [Symbol], default: [:all]

      validates :name, presence: true
      validates :route, presence: true

      def model_class
        scopes.inject(manifest.model_class_name.constantize) { |ar, scope| ar.send(scope) }
      end

      def engine_route(resource, params: {})
        manifest.context.engine.routes.url_helpers.send(route, resource, **params)
      end

      private

      def manifest
        Decidim.find_participatory_space_manifest(name)
      end
    end
  end
end
