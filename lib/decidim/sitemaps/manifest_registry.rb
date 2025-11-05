# frozen_string_literal: true

module Decidim
  module Sitemaps
    class ManifestRegistry < Decidim::ManifestRegistry
      private

      def manifest_class
        "Decidim::Sitemaps::#{@entity.to_s.classify}Manifest".constantize
      end
    end
  end
end
