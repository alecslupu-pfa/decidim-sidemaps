# frozen_string_literal: true

require "decidim/sitemaps/engine"
require "sitemap_generator"

module Decidim
  # This namespace holds the logic of the `Sitemaps` component. This component
  # allows users to create sitemaps in a participatory space.
  module Sitemaps
    autoload :Utilities, "decidim/sitemaps/utilities"
  end
end
