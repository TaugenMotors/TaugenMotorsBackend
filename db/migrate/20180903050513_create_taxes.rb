class CreateTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :taxes do |t|
      t.string  :name,       null: false
      t.decimal :percentage, null: false
      t.string  :tax_type,   null: false
      t.integer :status,     null: false, default: 0
      t.text    :description

      t.timestamps
    end
  end
end
