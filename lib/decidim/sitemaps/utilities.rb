# frozen_string_literal: true

require "sitemap_generator"

module Decidim
  module Sitemaps
    class Utilities
      # Copy templates/sitemap.rb to config if not there yet.
      def self.install_sitemap_rb(verbose:)
        config_file = SitemapGenerator.app.root.join("config/sitemap.rb")
        template_file = Pathname.new(__dir__).join("../../../templates/decidim_sitemap.rb")

        if config_file.exist?
          logger.info("already exists: config/sitemap.rb, file not copied") if verbose
        else
          FileUtils.cp(template_file, config_file)
          logger.info("created: config/sitemap.rb") if verbose
        end
      end

      def self.logger
        @logger ||= ActiveSupport::Logger.new($stdout)
      end
    end
  end
end
