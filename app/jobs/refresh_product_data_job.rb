class RefreshProductDataJob < ApplicationJob
  queue_as :default

  def perform(product_id)
    product = Product.find(product_id)
    updated_data = ProductScraper.new(product.url).scrape

    return unless updated_data && updated_data[:product_id].present?

    product.update(updated_data.except(:category))
    product.category.update(name: updated_data[:category])
  end
end
