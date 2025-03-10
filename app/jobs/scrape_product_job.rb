class ScrapeProductJob < ApplicationJob
  queue_as :default

  def perform(product_url)
    product_scraper = ProductScraper.new(product_url)
    product_data = product_scraper.scrape

    unless product_data && product_data[:product_id].present?
      broadcast_error(product_url)
      return
    end

    category = Category.find_or_initialize_by(name: product_data[:category])
    category.save

    product = category.products.find_or_initialize_by(
      product_id: product_data[:product_id],
      url: product_url
    )

    if product.update(product_data.except(:category))
      product.update(last_scraped_at: Time.current)
      broadcast_success(product, product_url)
    else
      broadcast_error(product_url, product.errors.full_messages)
    end
  end

  private

  def broadcast_success(product, product_url)
    puts "Broadcasting success for product: #{product_url}"
    puts "Broadcast payload: #{product.as_json(include: :category).inspect}"
    ActionCable.server.broadcast(
      "product_updates_#{Digest::MD5.hexdigest(product_url)}",
      {
        status: 'complete',
        product: product.as_json(include: :category)
      }
    )
  end

  def broadcast_error(url, errors = ['Failed to scrape product'])
    puts "Broadcasting error for product: #{url}, errors: #{errors}"
    ActionCable.server.broadcast(
      "product_updates_#{Digest::MD5.hexdigest(url)}",
      {
        status: 'error',
        url: url,
        errors: errors
      }
    )
  end
end
