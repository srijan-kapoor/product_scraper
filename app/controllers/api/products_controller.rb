class Api::ProductsController < ApplicationController

  def index
    @products = Product.includes(:category)

    if params[:query].present?
      @products = @products.where("title ILIKE ?", "%#{params[:query]}%")
    end

    @products = @products.all
    render :index
  end

  def create
    product_url = params[:product_url]

    return render json: { error: 'Invalid product URL' }, status: :unprocessable_entity unless URI.parse(product_url).is_a?(URI::HTTP)

    #TODO: add check based on last_scraped_at > 7 days condition, otherwise return product from db if present

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

    @product = product
    if product.persisted?
      render :show, status: :ok
    elsif product.update(product_data.except(:category))
      render :show, status: :created
    else
      render json: { error: product.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end
end
