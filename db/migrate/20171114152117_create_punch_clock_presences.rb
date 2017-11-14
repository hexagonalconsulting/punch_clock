class CreatePunchClockPresences < ActiveRecord::Migration[5.1]
  def change
    create_table :punch_clock_presences do |t|
      t.integer :user_id
      t.string :status, default: "offline"
      t.datetime :last_time_browser_open
      t.datetime :last_time_browser_active
      t.timestamps
    end
  end
end
