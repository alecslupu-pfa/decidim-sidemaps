# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Sitemaps
    # This is the engine that runs on the public interface of sitemaps.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Sitemaps

      initializer "decidim_sitemaps.register_spaces" do
        if Decidim.module_installed?(:participatory_processes)
          Decidim::Sitemaps.register_participatory_space(:participatory_processes) do |participatory_space|
            participatory_space.route = :participatory_process_path
            participatory_space.scopes = Decidim::Sitemaps.participatory_processes.fetch(:scopes, [:public_spaces])
          end
        end
      end
    end
  end
end
