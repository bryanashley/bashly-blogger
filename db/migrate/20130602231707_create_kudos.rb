class CreateKudos < ActiveRecord::Migration
  def change
    create_table :kudos do |t|
      t.references :post

      t.timestamps
    end
  end
end
