# frozen_string_literal: true

require "decidim/sitemaps/engine"
require "sitemap_generator"

module Decidim
  # This namespace holds the logic of the `Sitemaps` component. This component
  # allows users to create sitemaps in a participatory space.
  module Sitemaps
    include ActiveSupport::Configurable

    autoload :Utilities, "decidim/sitemaps/utilities"
    autoload :Generator, "decidim/sitemaps/generator"

    config_accessor :batch_size do
      100
    end

    config_accessor :static_pages do
      { enabled: true, changefreq: "daily", priority: 0.5 }
    end
  end
end
