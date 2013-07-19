class ChangesCommentContentToText < ActiveRecord::Migration
  def change
  	remove_column :comments, :content
  	add_column :comments, :content, :text
  end
end
