class CreateTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :terms do |t|
      t.string  :name,    null: false
      t.integer :days,    null: false
      t.integer :status,  null: false, default: 0

      t.timestamps
    end
  end
end
