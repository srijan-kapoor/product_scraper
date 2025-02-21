json.array! @products do |product|
  json.extract! product, :id, :title, :description, :price, :seller_name, :image_url, :size, :metadata, :product_id, :url
  json.category product.category, :name
end
