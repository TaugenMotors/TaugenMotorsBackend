class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      # Nombre del item (*)
      t.string :name, null: false
      # Referencia (*) único
      t.string :reference, null: false
      # Precio de venta (*) 
      t.decimal :price, null: false
      # Impuesto
      t.float :tax
      # Descripción 
      t.text :description
      # Proveedor
      t.string :provider
      # Status (*), default true.
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
