# frozen_string_literal: true

require "spec_helper"

describe "DebatesSitemaps" do
  let(:sitemap_options) { { include_root: false, verbose: false, compress: false, default_host: "https://#{organization.host}" } }
  let(:organization) { create(:organization, create_static_pages: false) }
  let!(:participatory_space) { create(:participatory_process, :published, organization:) }
  let!(:component) { create(:debates_component, :published, participatory_space:) }

  let(:sitemap) do
    SitemapGenerator::Sitemap.create(**sitemap_options) do
      organization = Decidim::Organization.first
      Decidim::Sitemaps::Generator.new(organization:, sitemap: self).generate_sitemap
    end
  end

  before do
    SitemapGenerator::Sitemap.reset!
    clean_sitemap_files_from_rails_app
    Decidim::Sitemaps.debates[:enabled] = true
  end

  context "when resources are not created" do
    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when the resource is created but closed" do
    let!(:resource) { create(:debate, :closed, component:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource is open" do
    let!(:resource) { create(:debate, component:) }

    it { expect(sitemap.link_count).to eq(2) }
  end

  context "when resource is published but moderated" do
    let!(:resource) { create(:debate, component:) }
    let!(:moderation) { create(:moderation, reportable: resource, hidden_at: 2.days.ago) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource has a custom scope" do
    around do |example|
      scopes = Decidim::Sitemaps.debates[:scopes]
      Decidim::Sitemaps.debates[:scopes] = [:closed]

      example.run

      Decidim::Sitemaps.debates[:scopes] = scopes
    end

    context "and there is no match" do
      let!(:resource) { create(:debate, component:) }

      it { expect(sitemap.link_count).to eq(1) }
    end

    context "and there is a match" do
      let!(:resource) { create(:debate, :closed, component:) }

      it { expect(sitemap.link_count).to eq(2) }
    end
  end
end
