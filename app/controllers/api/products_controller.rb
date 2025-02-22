class Api::ProductsController < ApplicationController
  def index
    @products = Product.includes(:category).all
    @products = @products.where('title ILIKE ?', "%#{params[:query]}%") if params[:query].present?

    render :index
  end

  def create
    product_url = params[:product_url]

    unless URI.parse(product_url).is_a?(URI::HTTP)
      return render json: { error: 'Invalid product URL' },
                    status: :unprocessable_entity
    end

    # product exist in db
    @product = Product.includes(:category).find_by(url: product_url)
    return render :show, status: :ok if @product

    # scrape if product not in db
    product_scraper = ProductScraper.new(product_url)
    product_data = product_scraper.scrape

    unless product_data && product_data[:product_id].present?
      return render json: { error: 'Invalid product data' }, status: :unprocessable_entity
    end

    category = Category.find_or_initialize_by(name: product_data[:category])
    category.save

    @product = category.products.find_or_initialize_by(
      product_id: product_data[:product_id],
      url: product_url
    )

    if @product.update(product_data.except(:category))
      @product.update(last_scraped_at: Time.current)
      render :show, status: :created
    else
      render json: { error: @product.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    @product = Product.find(params[:id])
    RefreshProductDataJob.perform_later(@product.id) if @product.last_scraped_at < 7.days.ago
    render :show, status: :ok
  end
end

