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

    # Check if product exists in db
    @product = Product.includes(:category).find_by(url: product_url)

    if @product
      render :show, status: :ok
    else
      # Enqueue the scraping job
      ScrapeProductJob.perform_later(product_url)
      render json: { message: 'Scraping initiated' }, status: :accepted
    end
  end

  def update
    @product = Product.find(params[:id])
    RefreshProductDataJob.perform_later(@product.id) if @product.last_scraped_at < 7.days.ago
    render :show, status: :ok
  end
end

