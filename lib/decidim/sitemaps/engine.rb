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

        if Decidim.module_installed?(:assemblies)
          Decidim::Sitemaps.register_participatory_space(:assemblies) do |participatory_space|
            participatory_space.route = :assembly_path
            participatory_space.scopes = Decidim::Sitemaps.assemblies.fetch(:scopes, [:public_spaces])
          end
        end

        if Decidim.module_installed?(:conferences)
          Decidim::Sitemaps.register_participatory_space(:conferences) do |participatory_space|
            participatory_space.route = :conference_path
            participatory_space.scopes = Decidim::Sitemaps.conferences.fetch(:scopes, [:public_spaces])
          end
        end
        if Decidim.module_installed?(:initiatives)
          Decidim::Sitemaps.register_participatory_space(:initiatives) do |participatory_space|
            participatory_space.route = :initiative_path
            participatory_space.scopes = Decidim::Sitemaps.initiatives.fetch(:scopes, [:public_spaces])
          end
        end
      end

      initializer "decidim_sitemaps.register_resource" do |_app|
        if Decidim.module_installed?(:meetings)
          Decidim::Sitemaps.register_component(:meetings) do |component|
            component.model_class_name = "Decidim::Meetings::Meeting"
            component.scopes = Decidim::Sitemaps.meetings.fetch(:scopes, [:published, :not_hidden, :not_withdrawn, :visible])
          end
        end
        if Decidim.module_installed?(:proposals)
          Decidim::Sitemaps.register_component(:proposals) do |component|
            component.model_class_name = "Decidim::Proposals::Proposal"
            component.scopes = Decidim::Sitemaps.proposals.fetch(:scopes, [:published, :not_hidden, :not_withdrawn])
          end
        end
      end
    end
  end
end
