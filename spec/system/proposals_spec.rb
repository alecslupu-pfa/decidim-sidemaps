# frozen_string_literal: true

require "spec_helper"

describe "MeetingsSitemaps" do
  let(:sitemap_options) { { include_root: false, verbose: false, compress: false, default_host: "https://#{organization.host}" } }
  let(:organization) { create(:organization, create_static_pages: false) }
  let!(:participatory_space) { create(:participatory_process, :published, organization:) }
  let!(:component) { create(:proposal_component, :published, participatory_space:) }

  let(:sitemap) do
    SitemapGenerator::Sitemap.create(**sitemap_options) do
      organization = Decidim::Organization.last
      Decidim::Sitemaps::Generator.new(organization:, sitemap: self).generate_sitemap
    end
  end

  before do
    SitemapGenerator::Sitemap.reset!
    clean_sitemap_files_from_rails_app
    Decidim::Sitemaps.meetings[:enabled] = true
  end

  context "when resources are not created" do
    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when the resource is created but not published" do
    let!(:resource) { create(:proposal, :unpublished, component:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource is published" do
    let!(:resource) { create(:proposal, :published, component:) }

    it { expect(sitemap.link_count).to eq(2) }
  end

  context "when resource is published but withdrawn" do
    let!(:resource) { create(:proposal, :published, :withdrawn, component:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource is published but moderated" do
    let!(:meeting) { create(:proposal, :published, :moderated, component:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource has a custom scope" do
    around do |example|
      scopes = Decidim::Sitemaps.proposals[:scopes]
      Decidim::Sitemaps.proposals[:scopes] = [:published, :not_hidden, :not_withdrawn, :accepted]

      example.run

      Decidim::Sitemaps.proposals[:scopes] = scopes
    end

    context "and there is no match" do
      let!(:meeting) { create(:proposal, :published, :rejected, component:) }

      it { expect(sitemap.link_count).to eq(1) }
    end

    context "and there is a match" do
      let!(:meeting) { create(:proposal, :published, :accepted, component:) }

      it { expect(sitemap.link_count).to eq(2) }
    end
  end
end
