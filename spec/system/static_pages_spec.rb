# frozen_string_literal: true

require "spec_helper"

describe "PagesSitemaps" do
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
    settings_list.without(:static_pages).each do |setting|
      Decidim::Sitemaps.send(setting.to_sym)[:enabled] = false
    end
    Decidim::Sitemaps.static_pages[:enabled] = true
  end

  context "when static pages are not created" do
    it { expect(sitemap.link_count).to eq(0) }
  end

  context "when static pages are created but not publicly accessible" do
    let!(:organization) { create(:organization, force_users_to_authenticate_before_access_organization: true) }
    let!(:static_page) { create(:static_page, allow_public_access: false, organization:) }

    it { expect(sitemap.link_count).to eq(0) }
  end

  context "when static pages are created with public access" do
    let!(:static_page) { create(:static_page, allow_public_access: true, organization:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when there are static pages topics" do
    let!(:static_page) { create(:static_page, :with_topic, allow_public_access: true, organization:) }

    it { expect(sitemap.link_count).to eq(1) }
  end
end
