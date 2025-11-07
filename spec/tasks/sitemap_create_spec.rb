# frozen_string_literal: true

require "spec_helper"

describe "rake sitemap:create", type: :task do
  let!(:organization) { create(:organization) }

  before do
    Decidim::Sitemaps::Utilities.install_sitemap_rb(verbose: false)
  end

  context "when executing task" do
    it "have to be executed without failures" do
      expect { task.execute }.not_to raise_error
    end
  end
end
