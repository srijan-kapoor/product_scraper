require 'rails_helper'

RSpec.describe Api::ProductsController, type: :request do
  describe 'POST /products' do
    let!(:category) { build(:category, name: 'Audio & Video') }
    let(:valid_url) { 'https://www.flipkart.com/some-product-url/p/test_product_id' }
    let(:invalid_url) { '123' }

    before do
      allow_any_instance_of(ProductScraper).to receive(:scrape).and_return(
        {
          product_id: 'test_product_id',
          title: 'Test Product',
          price: '₹1,599',
          size: 'Medium',
          category: 'Audio & Video',
          seller_name: 'Test Seller',
          description: 'Test description',
          metadata: { color: 'Red', material: 'Cotton' }
        }
      )
    end

    context 'when product does not exist' do
      it 'enqueues a scraping job' do
        expect {
          post '/api/products.json', params: { product_url: valid_url }
        }.to have_enqueued_job(ScrapeProductJob).with(valid_url)

        expect(response).to have_http_status(:accepted)
        expect(JSON.parse(response.body)['message']).to eq('Scraping initiated')
      end
    end

    context 'when product already exists' do
      let!(:product) { create(:product, product_id: 'test_product_id', category: category) }

      it 'returns the existing product' do
        expect {
          post '/api/products.json', params: { product_url: valid_url }
        }.to_not change(Product, :count)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['product']['product_id']).to eq('test_product_id')
      end
    end

    context 'when product URL is invalid' do
      it 'returns an error' do
        post '/api/products.json', params: { product_url: invalid_url }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Invalid product URL')
      end
    end
  end

  describe 'GET /products' do
    context 'when no query is provided' do
      it 'returns all products' do
        get '/api/products.json'
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(Product.count)
      end
    end

    context 'when a query is provided' do
      it 'returns products that match the query' do
        get '/api/products.json', params: { query: 'Test' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(Product.where('title ILIKE ?', '%test%').count)
      end
    end
  end

  describe 'PUT /products/:id' do
    let!(:category) { create(:category, name: 'Audio & Video') }
    let!(:product) { create(:product, product_id: 'test_product_id', category: category) }

    it 'enqueues the job if the product was scraped more than 7 days ago' do
      product.update(last_scraped_at: 8.days.ago)
      put "/api/products/#{product.id}.json"

      expect(response).to have_http_status(:ok)
      expect(RefreshProductDataJob).to have_been_enqueued.with(product.id)
    end

    it 'does not enqueue the job if the product was scraped in the last 7 days' do
      product.update(last_scraped_at: 6.days.ago)
      put "/api/products/#{product.id}.json"
      expect(RefreshProductDataJob).not_to have_been_enqueued
    end
  end
end
