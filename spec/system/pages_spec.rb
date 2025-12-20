# frozen_string_literal: true

require "spec_helper"

describe "PagesSitemaps" do
  let(:sitemap_options) { { include_root: false, verbose: false, compress: false, default_host: "https://#{organization.host}" } }
  let(:organization) { create(:organization, create_static_pages: false) }
  let!(:participatory_space) { create(:participatory_process, :published, organization:) }

  let!(:component) { create(:component, :published, participatory_space:, manifest_name: "pages") }

  let(:sitemap) do
    SitemapGenerator::Sitemap.create(**sitemap_options) do
      organization = Decidim::Organization.last
      Decidim::Sitemaps::Generator.new(organization:, sitemap: self).generate_sitemap
    end
  end

  before do
    SitemapGenerator::Sitemap.reset!
    clean_sitemap_files_from_rails_app
    Decidim::Sitemaps.pages[:enabled] = true
  end

  context "when resources are not created" do
    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when the component is not published" do
    let!(:component) { create(:component, participatory_space:, published_at: 3.days.from_now, manifest_name: "pages") }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource is published" do
    let!(:resource) { create(:page, component:) }

    it { expect(sitemap.link_count).to eq(2) }
  end
end
