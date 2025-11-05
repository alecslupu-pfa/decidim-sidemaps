# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Sitemaps
    # This is the engine that runs on the public interface of sitemaps.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Sitemaps
    end
  end
end
