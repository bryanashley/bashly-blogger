class Comment < ActiveRecord::Base
  belongs_to :post  
  belongs_to :commenter 
  validates_presence_of :content
end
