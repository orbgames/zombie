class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :physical_device_id, null: false
      t.integer :ip
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
