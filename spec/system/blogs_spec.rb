# frozen_string_literal: true

require "spec_helper"

describe "BlogsgsSitemaps" do
  let(:sitemap_options) { { include_root: false, verbose: false, compress: false, default_host: "https://#{organization.host}" } }
  let(:organization) { create(:organization, create_static_pages: false) }
  let!(:participatory_space) { create(:participatory_process, :published, organization:) }
  let!(:component) { create(:post_component, :published, participatory_space:) }

  let(:sitemap) do
    SitemapGenerator::Sitemap.create(**sitemap_options) do
      organization = Decidim::Organization.last
      Decidim::Sitemaps::Generator.new(organization:, sitemap: self).generate_sitemap
    end
  end

  before do
    SitemapGenerator::Sitemap.reset!
    clean_sitemap_files_from_rails_app
    Decidim::Sitemaps.blogs[:enabled] = true
  end

  context "when resources are not created" do
    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when the resource is created but not published" do
    let!(:resource) { create(:post, published_at: 3.hours.from_now, component:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource is published" do
    let!(:resource) { create(:post, published_at: 2.days.ago, component:) }

    it { expect(sitemap.link_count).to eq(2) }
  end
end
