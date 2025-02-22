class AddLastScrapedAtToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :last_scraped_at, :datetime
  end
end
