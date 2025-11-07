# frozen_string_literal: true

require "spec_helper"

describe "InitiativesSitemaps" do
  let(:sitemap_options) { { include_root: false, verbose: false, compress: false, default_host: "https://#{organization.host}" } }
  let!(:organization) { create(:organization, create_static_pages: false) }

  let(:sitemap) do
    SitemapGenerator::Sitemap.create(**sitemap_options) do
      organization = Decidim::Organization.last
      Decidim::Sitemaps::Generator.new(organization:, sitemap: self).generate_sitemap
    end
  end

  before do
    SitemapGenerator::Sitemap.reset!
    clean_sitemap_files_from_rails_app
    Decidim::Sitemaps.initiatives[:enabled] = true
  end

  context "when participatory space are not created" do
    it { expect(sitemap.link_count).to eq(0) }
  end

  context "when participatory space is not published" do
    let!(:participatory_space) { create(:initiative, :unpublished, organization:) }

    it { expect(sitemap.link_count).to eq(0) }
  end

  context "when participatory space is published" do
    let!(:participatory_space) { create(:initiative, :published, organization:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when participatory space has a custom scope" do
    around do |example|
      scopes = Decidim::Sitemaps.initiatives[:scopes]
      Decidim::Sitemaps.initiatives[:scopes] = [:public_spaces, :discarded]

      example.run

      Decidim::Sitemaps.initiatives[:scopes] = scopes
    end

    context "and there is no match" do
      let!(:participatory_space) { create(:initiative, :published, organization:) }

      it { expect(sitemap.link_count).to eq(0) }
    end

    context "and there is a match" do
      let!(:participatory_space) { create(:initiative, :published, :discarded, organization:) }

      it { expect(sitemap.link_count).to eq(1) }
    end
  end
end
