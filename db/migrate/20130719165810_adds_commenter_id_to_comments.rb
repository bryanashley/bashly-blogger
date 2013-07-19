class AddsCommenterIdToComments < ActiveRecord::Migration
  def change
  	add_column :comments, :commenter_id, :integer
  end
end
