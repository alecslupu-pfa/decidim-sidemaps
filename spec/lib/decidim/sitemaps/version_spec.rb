# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Sitemaps do
    subject { described_class }

    it "has version" do
      expect(subject::VERSION).to eq("0.29.1")
    end
  end
end
