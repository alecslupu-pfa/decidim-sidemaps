# frozen_string_literal: true

require "decidim/core/test/factories"

require "decidim/assemblies/test/factories" if Decidim.module_installed?(:assemblies)
require "decidim/conferences/test/factories" if Decidim.module_installed?(:conferences)
require "decidim/initiatives/test/factories" if Decidim.module_installed?(:initiatives)
require "decidim/participatory_processes/test/factories" if Decidim.module_installed?(:participatory_processes)

require "decidim/blogs/test/factories" if Decidim.module_installed?(:blogs)
require "decidim/meetings/test/factories" if Decidim.module_installed?(:meetings)
require "decidim/proposals/test/factories" if Decidim.module_installed?(:proposals)
require "decidim/debates/test/factories" if Decidim.module_installed?(:debates)
require "decidim/sortitions/test/factories" if Decidim.module_installed?(:sortitions)

if Decidim.module_installed?(:pages)
  begin
    require "decidim/pages/test/factories"
  rescue LoadError
    # UGLY HACK TO MAKE THE TESTS WORK
    FactoryBot.define do
      factory :page_component, parent: :component do
        name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :pages).i18n_name }
        manifest_name { :pages }
        participatory_space { create(:participatory_process, :with_steps, organization:) }
      end

      factory :page, class: "Decidim::Pages::Page" do
        body { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
        component { build(:component, manifest_name: "pages") }
      end
    end
  end
end
