# frozen_string_literal: true

require "spec_helper"

describe "SortitionsSitemaps" do
  let(:sitemap_options) { { include_root: false, verbose: false, compress: false, default_host: "https://#{organization.host}" } }
  let(:organization) { create(:organization, create_static_pages: false) }
  let!(:participatory_space) { create(:participatory_process, :published, organization:) }
  let!(:component) { create(:sortition_component, :published, participatory_space:) }
  let!(:decidim_proposals_component) { create(:proposal_component, :published, participatory_space:) }

  let(:sitemap) do
    SitemapGenerator::Sitemap.create(**sitemap_options) do
      organization = Decidim::Organization.first
      Decidim::Sitemaps::Generator.new(organization:, sitemap: self).generate_sitemap
    end
  end

  before do
    SitemapGenerator::Sitemap.reset!
    clean_sitemap_files_from_rails_app
    Decidim::Sitemaps.sortitions[:enabled] = true
    Decidim::Sitemaps.proposals[:enabled] = false
  end

  context "when resources are not created" do
    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when the resource is created but cancelled" do
    let!(:resource) { create(:sortition, :cancelled, decidim_proposals_component:, component:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource is open" do
    let!(:resource) { create(:sortition, decidim_proposals_component:, component:) }

    it { expect(sitemap.link_count).to eq(2) }
  end

  context "when resource has a custom scope" do
    around do |example|
      scopes = Decidim::Sitemaps.sortitions[:scopes]
      Decidim::Sitemaps.sortitions[:scopes] = [:cancelled]

      example.run

      Decidim::Sitemaps.sortitions[:scopes] = scopes
    end

    context "and there is no match" do
      let!(:resource) { create(:sortition, decidim_proposals_component:, component:) }

      it { expect(sitemap.link_count).to eq(1) }
    end

    context "and there is a match" do
      let!(:resource) { create(:sortition, :cancelled, decidim_proposals_component:, component:) }

      it { expect(sitemap.link_count).to eq(2) }
    end
  end
end
