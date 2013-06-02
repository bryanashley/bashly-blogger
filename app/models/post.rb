class Post < ActiveRecord::Base
  belongs_to :user

  attr_accessor :tagline
  validates_presence_of :content, :subtitle, :title, :tagline
  before_create :form_tags

  
  private 

  def form_tags
    self.tags = self.tagline.split(",").map{|t| t.strip()}
  end

end
