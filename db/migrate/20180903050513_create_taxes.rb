class CreateTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :taxes do |t|
      # Nombre del item (*)
      t.string :name, null: false
      # Porcentaje (*) 
      t.decimal :percentage, null: false
      # Descripción 
      t.text :description
      # Type (*)
      t.string :tax_type, null: false
      # Status (*), default true.
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
