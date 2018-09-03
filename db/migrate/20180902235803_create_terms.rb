class CreateTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :terms do |t|
      # Nombre del término (*)
      t.string :name, null: false
      # Días (*)
      t.integer :days, null: false
      # Status (*), default true.
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
