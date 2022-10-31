class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :app_token

      t.timestamps
    end
    add_index :applications, :app_token, unique: true
  end
end
