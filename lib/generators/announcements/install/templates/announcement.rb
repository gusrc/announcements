class Announcement < ActiveRecord::Base

  before_create :set_default_times

  validates_presence_of :body

  attr_accessible :body, :visible_at, :invisible_at
  
  def self.newest
    Announcement.where("visible_at <= ? AND (invisible_at is null OR invisible_at >= ?)", Time.now, Time.now).last
  end
  
  def self.newest_private
    Announcement.where("type is null").order("id desc").first
  end

  def self.newest_public
    Announcement.where("type = 'public'").order("id desc").first
  end

  private

    def set_default_times
      self.visible_at ||= Time.now
      self.invisible_at ||= nil
    end
  
end
