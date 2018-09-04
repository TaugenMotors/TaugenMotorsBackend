class CreateWithholdings < ActiveRecord::Migration[5.2]
  def change
    create_table :withholdings do |t|
      t.string  :name,              null: false
      t.decimal :percentage,        null: false
      t.string  :withholding_type,  null: false
      t.integer :status,            null: false, default: 0
      t.text    :description

      t.timestamps
    end
  end
end
