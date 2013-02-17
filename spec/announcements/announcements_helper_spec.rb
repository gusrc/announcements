require 'spec_helper'
include ActionView::Context
include ActionView::Helpers
include AnnouncementsHelper

describe AnnouncementsHelper do

  before do
    @time_now = Time.now
    Time.stub!(:now).and_return(@time_now)

    @announcement = Announcement.new
    @announcement.id = 1
    @announcement.body = "announcement text"
    
    @mocked_cookies = Hash.new
    stub!(:cookies).and_return(@mocked_cookies)
  end

  it "should output announcement text with no params" do
    @mocked_cookies["announcement_1"] = "not hidden"
    output = announce(@announcement)
    output.should include("x")
    output.should include("announcement text")
  end

  it "should not output announcement if was already hidden by user" do
    @mocked_cookies["announcement_1"] = "hidden"
    output = announce(@announcement)
    output.should be_nil
  end

  it "should output custom hide message and div class" do
    @mocked_cookies["announcement_1"] = "not hidden"
    output = announce(@announcement, hide_message: "X", div_class: "customdiv")
    output.should include("<div class=\"customdiv\"")
    output.should include(">X</span>")
  end

  it "should output bootstrap style" do 
    @mocked_cookies["announcement_1"] = "not hidden"
    output = announce(@announcement, format: "bootstrap")
    output.should include("<a class=\"close\"")
    output.should include("<h4 class=\"alert-heading\"")
  end

  it "should output nil if no announcement is found" do
    @announcement = nil
    output = announce(@announcement)
    output.should be_nil
  end

  it "should set nil as default invisible_at time" do
    @announcement.invisible_at.should be_nil
  end

  it "should set now as default visible_at time" do
    @announcement.visible_at.should equal Time.now
  end

  it "should not output announcement before the visible_at time" do
    @announcement.visible_at = Time.now + 1.day
    output = announce(@announcement)
    output.should be_nil
  end

  it "should output announcement after the visible_at time" do
    @announcement.visible_at = Time.now
    output = announce(@announcement)
    output.should include "announcement text"
  end

  it "should output announcement before the invisible_at time" do
    @announcement.invisible_at = Time.now + 5.weeks
    output = announce(@announcement)
    output.should include "announcement text"
  end

  it "should not output announcement after the invisible_at time" do
    @announcement.visible_at = Time.now - 2.weeks
    @announcement.invisible_at = Time.now - 1.day
    output = announce(@announcement)
    output.should be_nil
  end

  it "should always output announcement when invisible_at is nil" do
    output = announce(@announcement)
    output.should include "announcement text"
  end

end