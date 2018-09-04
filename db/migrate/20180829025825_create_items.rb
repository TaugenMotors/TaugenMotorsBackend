class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string  :name,        null: false
      t.string  :reference,   null: false
      t.decimal :price,       null: false
      t.integer :status,      null: false, default: 0
      t.text    :description
      t.string  :provider
      t.float   :tax

      t.timestamps
    end
  end
end
