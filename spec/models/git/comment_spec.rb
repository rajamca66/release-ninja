require 'rails_helper'

RSpec.describe Git::Comment do
  let(:normal_comment) { "This is just a normal comment" }
  let(:bug_fix_comment) {
    "# Bug Fix - Fixing up a bug\n" \
    "\n" \
    "The bug is fixed"
  }
  let(:minor_comment) {
    "# New Feature - Added a feature\n" \
    "\n" \
    "The feature is new\n" \
    "Cool,;#!- huh?\n"
  }
  let(:major_comment) {
    "# Major Feature - Really cool shit" \
    "\n" \
    "This is cool\n" \
    "\n" \
    "With even more *coolness*"
  }
  let(:feature_comment) {
    "# Feature - Really awesome" \
    "\n" \
    "Test"
  }
  let(:fix_comment) {
    "## Fix - Test test" \
    "\n" \
    "Test test"
  }

  describe "#release_note?" do
    it "normal is false" do
      expect(Git::Comment.new(normal_comment).release_note?).to eq(false)
    end

    it "bug fix is true" do
      expect(Git::Comment.new(bug_fix_comment).release_note?).to eq(true)
    end

    it "minor is true" do
      expect(Git::Comment.new(minor_comment).release_note?).to eq(true)
    end

    it "major is true" do
      expect(Git::Comment.new(major_comment).release_note?).to eq(true)
    end

    it "feature is true" do
      expect(Git::Comment.new(feature_comment).release_note?).to eq(true)
    end
  end

  describe "#type" do
    it "normal" do
      expect(Git::Comment.new(normal_comment).type).to eq(nil)
    end

    it "feature" do
      expect(Git::Comment.new(feature_comment).type).to eq(:feature)
    end

    it "new fix style" do
      expect(Git::Comment.new(fix_comment).type).to eq(:fix)
    end

    it "fix" do
      expect(Git::Comment.new(bug_fix_comment).type).to eq(:fix)
    end

    it "minor" do
      expect(Git::Comment.new(minor_comment).type).to eq(:feature)
    end

    it "major" do
      expect(Git::Comment.new(major_comment).type).to eq(:feature)
    end
  end

  describe "#title" do
    it "is nil for not release note" do
      expect(Git::Comment.new(normal_comment).title).to eq(nil)
    end

    it "finds the title after -" do
      expect(Git::Comment.new(minor_comment).title).to eq("Added a feature")
    end

    it "handles multiple -'s'" do
      expect(Git::Comment.new("# Bug Fix - This is - so - cool").title).to eq("This is - so - cool")
    end

    it "handles the new feature style" do
      expect(Git::Comment.new(feature_comment).title).to eq("Really awesome")
    end

    it "handles the new bug style" do
      expect(Git::Comment.new(fix_comment).title).to eq("Test test")
    end
  end

  describe "#note_body" do
    it "is empty for wrong format" do
      expect(Git::Comment.new(normal_comment).title).to eq(nil)
    end

    it "handles 1 line note body" do
      expect(Git::Comment.new(bug_fix_comment).note_body).to eq("The bug is fixed")
    end

    it "handles multi line note body" do
      expect(Git::Comment.new(minor_comment).note_body).to eq("The feature is new\nCool,;#!- huh?")
    end
  end
end
