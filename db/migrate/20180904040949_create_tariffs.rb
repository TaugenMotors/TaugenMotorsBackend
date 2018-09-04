class CreateTariffs < ActiveRecord::Migration[5.2]
  def change
    create_table :tariffs do |t|
      t.string  :driver_name,   null: false
      t.string  :vehicle_plate, null: false
      t.string  :shift_name
      t.date    :shift_date
      t.integer :status,        null: false, default: 0
      t.decimal :owner_tariff,  null: false
      t.decimal :paid,          null: false
      t.decimal :debt,          null: false
      t.text    :comments

      t.timestamps
    end
  end
end
