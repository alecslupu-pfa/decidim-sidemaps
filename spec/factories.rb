# frozen_string_literal: true

require "decidim/core/test/factories"

require "decidim/assemblies/test/factories" if Decidim.module_installed?(:assemblies)
require "decidim/conferences/test/factories" if Decidim.module_installed?(:conferences)
require "decidim/initiatives/test/factories" if Decidim.module_installed?(:initiatives)
require "decidim/participatory_processes/test/factories" if Decidim.module_installed?(:participatory_processes)

require "decidim/blogs/test/factories" if Decidim.module_installed?(:blogs)
require "decidim/meetings/test/factories" if Decidim.module_installed?(:meetings)
require "decidim/proposals/test/factories" if Decidim.module_installed?(:proposals)
