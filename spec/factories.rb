# frozen_string_literal: true

require "decidim/core/test/factories"

require "decidim/assemblies/test/factories" if Decidim.module_installed?(:assemblies)
require "decidim/participatory_processes/test/factories" if Decidim.module_installed?(:participatory_processes)
require "decidim/conferences/test/factories" if Decidim.module_installed?(:conferences)
