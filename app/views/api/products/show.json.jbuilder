json.product do
  json.extract! @product, :title, :description, :price, :seller_name, :image_url, :size, :metadata, :product_id, :url

  json.category do
    json.extract! @product.category, :name
  end
end
