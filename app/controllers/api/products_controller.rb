class Api::ProductsController < ApplicationController
  def create
    product_url = params[:product_url]

    return render json: { error: 'Invalid product URL' }, status: :unprocessable_entity unless product_url

    #TODO: add check based on last_scraped_at > 7 days condition, otherwise return product from db

    product_scraper = ProductScraper.new(product_url)
    product_data = product_scraper.scrape

    unless product_data && product_data[:product_id].present?
      return render json: { error: 'Invalid product data' }, status: :unprocessable_entity 
    end

    category = Category.find_or_initialize_by(
                        name: product_data[:category])
    category.save

    product = category.products.find_or_initialize_by(
                                product_id: product_data[:product_id], 
                                url: product_url)

    product.update(product_data.except(:category))

    if product.persisted?
      render json: product, status: :created
    else
      render json: { error: 'Failed to create product' }, status: :unprocessable_entity
    end
  end
end
