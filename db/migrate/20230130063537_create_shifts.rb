class CreateShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :shifts do |t|
      t.date :date
      t.integer :slot
      t.references :worker

      t.timestamps
    end
  end
end
