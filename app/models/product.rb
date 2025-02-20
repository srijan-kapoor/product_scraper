class Product < ApplicationRecord
  validates :title, :product_id, :url, presence: true
  validates :product_id, uniqueness: true
  validates :url, uniqueness: true

  belongs_to :category
end
