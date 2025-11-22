# frozen_string_literal: true

module Decidim
  module Sitemaps
    class ComponentManifest
      include ActiveModel::Model
      include Decidim::AttributeObject::Model

      attribute :model_class_name, String
      attribute :name, Symbol
      attribute :scopes, [Symbol], default: [:all]
      validates :name, presence: true

      def resource_route(resource, host:, params: {})
        ResourceLocatorPresenter.new(resource).url(params.merge(host:))
      end

      def model_class
        model_class_name.constantize
      end
    end
  end
end
