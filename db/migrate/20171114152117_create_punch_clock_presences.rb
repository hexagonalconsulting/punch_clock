class CreatePunchClockPresences < ActiveRecord::Migration[5.1]
  def change
    create_table :punch_clock_presences do |t|

      t.timestamps
    end
  end
end
