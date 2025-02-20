class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.string :description
      t.string :size
      t.decimal :price, precision: 10, scale: 2
      t.string :seller_name
      t.jsonb :metadata
      t.string :product_id, null: false
      t.string :url, null: false
      t.string :image_url
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :products, :product_id, unique: true
    add_index :products, :url, unique: true
  end
end
