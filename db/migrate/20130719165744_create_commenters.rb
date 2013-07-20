class CreateCommenters < ActiveRecord::Migration
  def change
    create_table :commenters do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :avatar
      t.string :url

      t.timestamps
    end
  end
end
