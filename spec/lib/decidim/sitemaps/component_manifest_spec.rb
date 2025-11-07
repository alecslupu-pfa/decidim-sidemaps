# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Sitemaps
    describe ComponentManifest do
      subject do
        described_class.new(
          model_class_name: manager_class,
          name:,
          scopes:
        )
      end

      let(:scopes) { [:all] }
      let(:manager_class) { "Decidim::Dev::DummyResource" }
      let(:name) { :dummy_resource }

      context "when no name is set" do
        let(:name) { nil }

        it { is_expected.to be_invalid }
      end

      describe "when adding settings" do
        it "is valid" do
          expect(subject).to be_valid
          expect(subject.attributes).to have_key(:scopes)
        end
      end

      describe "resource_route" do
        let(:resource) { create(name) }

        it { expect(subject.resource_route(resource)).to eq("/processes/#{resource.participatory_space.slug}/f/#{resource.component.id}/dummy_resources/#{resource.id}") }
      end

      describe "model_class" do
        it "receives the scopes" do
          scopes.each do |scope|
            expect(manager_class.constantize).to receive(scope)
            subject.model_class
          end
        end
      end
    end
  end
end
