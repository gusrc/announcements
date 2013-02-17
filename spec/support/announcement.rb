class Announcement
  attr_accessor :body
  attr_accessor :id
  attr_accessor :visible_at
  attr_accessor :invisible_at

  def initialize
  	@visible_at = Time.now
  end
end