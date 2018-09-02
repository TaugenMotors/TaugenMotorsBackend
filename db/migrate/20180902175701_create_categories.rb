class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      # Nombre del item (*)
      t.string :name, null: false
      # Descripción (*)
      t.text :description, null: false

      t.timestamps
    end
  end
end
