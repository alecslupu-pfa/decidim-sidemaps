# frozen_string_literal: true

require "spec_helper"

describe "MeetingsSitemaps" do
  let(:sitemap_options) { { include_root: false, verbose: false, compress: false, default_host: "https://#{organization.host}" } }
  let(:organization) { create(:organization, create_static_pages: false) }
  let!(:participatory_space) { create(:participatory_process, :published, organization:) }
  let!(:component) { create(:meeting_component, :published, participatory_space:) }

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
    let!(:meeting) { create(:meeting, component:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource is published" do
    let!(:meeting) { create(:meeting, :published, component:) }

    it { expect(sitemap.link_count).to eq(2) }
  end

  context "when resource is published but withdrawn" do
    let!(:meeting) { create(:meeting, :published, :withdrawn, component:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource is published but private" do
    let!(:meeting) { create(:meeting, :published, private_meeting: true, transparent: false, component:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when resource is published but moderated" do
    let!(:meeting) { create(:meeting, :published, :moderated, component:) }

    it { expect(sitemap.link_count).to eq(1) }
  end

  context "when participatory space has a custom scope" do
    around do |example|
      scopes = Decidim::Sitemaps.meetings[:scopes]
      Decidim::Sitemaps.meetings[:scopes] = [:published, :not_hidden, :not_withdrawn, :visible, :in_person]

      example.run

      Decidim::Sitemaps.meetings[:scopes] = scopes
    end

    context "and there is no match" do
      let!(:meeting) { create(:meeting, :published, :online, component:) }

      it { expect(sitemap.link_count).to eq(1) }
    end

    context "and there is a match" do
      let!(:meeting) { create(:meeting, :published, :in_person, component:) }

      it { expect(sitemap.link_count).to eq(2) }
    end
  end
end
