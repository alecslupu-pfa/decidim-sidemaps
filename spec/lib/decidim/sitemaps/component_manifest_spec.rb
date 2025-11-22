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
        let(:organization) { resource.participatory_space.organization }

        it { expect(subject.resource_route(resource, host: organization.host)).to eq("http://#{organization.host}:#{Capybara.server_port}/processes/#{resource.participatory_space.slug}/f/#{resource.component.id}/dummy_resources/#{resource.id}") }
      end
    end
  end
end
