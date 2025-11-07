# frozen_string_literal: true

require "spec_helper"

describe "ParticipatoryProcessSitemaps" do
  let(:sitemap_options) { { include_root: false, verbose: false, compress: false, default_host: "https://#{organization.host}" } }
  let!(:organization) { create(:organization, create_static_pages: false) }

  let(:settings_list) do
    %w()
  end

  let(:sitemap) do
    SitemapGenerator::Sitemap.create(**sitemap_options) do
      organization = Decidim::Organization.last
      Decidim::Sitemaps::Generator.new(organization:, sitemap: self).generate_sitemap
    end
  end

  before do
    SitemapGenerator::Sitemap.reset!
    clean_sitemap_files_from_rails_app
    settings_list.each do |setting|
      Decidim::Sitemaps.send(setting.to_sym)[:enabled] = false
    end
    Decidim::Sitemaps.participatory_processes[:enabled] = true
  end

  context "when participatory process are not created" do
    it { expect(sitemap.link_count).to eq(0) }
  end

  context "when participatory process is not published" do
    let!(:participatory_process) { create(:participatory_process, :unpublished, organization:) }

    it { expect(sitemap.link_count).to eq(0) }
  end

  context "when participatory process is published" do
    let!(:participatory_process) { create(:participatory_process, :published, organization:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when participatory process is published but private" do
    let!(:participatory_process) { create(:participatory_process, :published, :private, organization:) }

    it { expect(sitemap.link_count).to eq(0) }
  end

  context "when participatory process has a custom scope" do
    around do |example|
      scopes = Decidim::Sitemaps.participatory_processes[:scopes]
      Decidim::Sitemaps.participatory_processes[:scopes] = [:public_spaces, :upcoming]

      example.run

      Decidim::Sitemaps.participatory_processes[:scopes] = scopes
    end

    context "and there is no match" do
      let!(:participatory_process) { create(:participatory_process, :published, :past, organization:) }

      it { expect(sitemap.link_count).to eq(0) }
    end

    context "and there is a match" do
      let!(:participatory_process) { create(:participatory_process, :published, :upcoming, organization:) }

      it { expect(sitemap.link_count).to eq(1) }
    end
  end
end
