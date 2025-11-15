# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Sitemaps
    describe ParticipatorySpaceManifest do
      subject do
        described_class.new(
          name:,
          route:,
          scopes:
        )
      end

      let(:name) { :participatory_processes }
      let(:route) { :participatory_processes }
      let(:scopes) { [:all] }

      context "when no name is set" do
        let(:name) { nil }

        it { is_expected.to be_invalid }
      end

      describe "model_class" do
        it "receives the scopes" do
          scopes.each do |scope|
            expect(Decidim::ParticipatoryProcess).to receive(scope)
            subject.model_class
          end
        end
      end
    end
  end
end
