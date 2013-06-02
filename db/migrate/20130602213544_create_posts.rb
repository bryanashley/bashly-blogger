class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :subtitle
      t.text :content
      t.text :tags, array: true

      t.references :user

      t.timestamps
    end
  end
end
