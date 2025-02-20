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
      it 'creates a new product' do
        expect {
          post '/api/products', params: { product_url: valid_url }
        }.to change(Product, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).to eq('Test Product')
      end
    end

    context 'when product already exists' do
      let!(:product) { create(:product, product_id: 'test_product_id', category: category) }

      it 'returns the existing product' do
        expect {
          post '/api/products', params: { product_url: valid_url }
        }.to_not change(Product, :count)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['product_id']).to eq('test_product_id')
      end
    end

    context 'when product URL is invalid' do
      it 'returns an error' do
        post '/api/products', params: { product_url: invalid_url }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Invalid product URL')
      end
    end

    context 'when scraping fails' do
      before do
        allow_any_instance_of(ProductScraper).to receive(:scrape).and_return(nil)
      end

      it 'returns an error' do
        post '/api/products', params: { product_url: valid_url }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Invalid product data')
      end
    end
  end
end
