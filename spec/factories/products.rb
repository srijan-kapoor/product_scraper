FactoryBot.define do
  factory :product do
    product_id { "test_product_id" }
    url { "https://www.flipkart.com/some-product-url/p/test_product_id" }
    title { "Test Product" }
    price { "₹1000" }
    size { "Medium" }
    seller_name { "Test Seller" }
    description { "Test product description." }
    metadata {{"Model Name"=>"snp album tan 4775",
      "Bag Size"=>"Mini",
      "Other Body Features"=>"brown wallet",
      "Number of Card Slots"=>"9",
      "Material"=>"Artificial Leather",
      "Color"=>"Tan",
      "Net Quantity"=>"1",
      "Width"=>"10 cm"}}
    category
    image_url { "https://www.flipkart.com/some-product-url/p/test_product_id/image.jpg" }
  end
end
