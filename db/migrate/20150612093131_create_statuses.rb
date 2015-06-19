class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :unique_id
      t.datetime :datetime
      t.string :provider
      t.string :content
      t.string :contentimg
      t.string :bywhom
      t.string :bywhomimg
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
