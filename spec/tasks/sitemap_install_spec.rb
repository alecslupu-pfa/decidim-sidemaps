# frozen_string_literal: true

require "spec_helper"

describe "rake sitemap:install", type: :task do
  context "when executing task" do
    it "have to be executed without failures" do
      expect { task.execute }.not_to raise_error
    end
  end
end
