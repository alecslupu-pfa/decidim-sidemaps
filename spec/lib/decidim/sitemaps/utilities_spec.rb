# frozen_string_literal: true

require "spec_helper"
module Decidim
  module Sitemaps
    describe Utilities do
      let(:config_file) { SitemapGenerator.app.root.join("config/decidim_sitemap.rb") }
      let(:logger_double) { instance_double(ActiveSupport::Logger) }

      before do
        config_file.delete if config_file.exist?
        # Stub the logger class method to return our double
        allow(Decidim::Sitemaps::Utilities).to receive(:logger).and_return(logger_double)
        # Allow the logger to receive info calls by default
        allow(logger_double).to receive(:info)
      end

      it "creates the config file" do
        expect(config_file).not_to exist
        Decidim::Sitemaps::Utilities.install_sitemap_rb(verbose: false)
        expect(config_file).to exist
      end

      describe "when is verbose" do
        let(:verbose) { true }
        it "outputs information on config file being copied" do
          expect(logger_double).to receive(:info).with("created: config/decidim_sitemap.rb")
          Decidim::Sitemaps::Utilities.install_sitemap_rb(verbose:)
        end

        it "outputs information on config file already being present" do
          Decidim::Sitemaps::Utilities.install_sitemap_rb(verbose:)
          expect(logger_double).to receive(:info).with("already exists: config/decidim_sitemap.rb, file not copied")
          Decidim::Sitemaps::Utilities.install_sitemap_rb(verbose:)
        end
      end

      describe "when is not verbose" do
        let(:verbose) { false }
        it "outputs information on config file being copied" do
          expect(logger_double).not_to receive(:info).with("created: config/decidim_sitemap.rb")
          Decidim::Sitemaps::Utilities.install_sitemap_rb(verbose:)
        end

        it "outputs information on config file already being present" do
          Decidim::Sitemaps::Utilities.install_sitemap_rb(verbose:)
          expect(logger_double).not_to receive(:info).with("already exists: config/decidim_sitemap.rb, file not copied")
          Decidim::Sitemaps::Utilities.install_sitemap_rb(verbose:)
        end
      end
    end
  end
end
