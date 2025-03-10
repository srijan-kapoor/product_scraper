require 'rails_helper'

RSpec.describe ScrapeProductJob, type: :job do
  let(:product_url) { 'https://www.example.com/product' }
  let(:product_data) do
    {
      product_id: 'test_product_id',
      title: 'Test Product',
      price: '₹1,599',
      size: 'Medium',
      category: 'Audio & Video',
      seller_name: 'Test Seller',
      description: 'Test description',
    }
  end

  before do
    allow(ActionCable.server).to receive(:broadcast)
  end

  context 'when scraping is successful' do
    before do
      allow_any_instance_of(ProductScraper).to receive(:scrape).and_return(product_data)
    end

    it 'broadcasts a success message' do
      expect {
        described_class.perform_now(product_url)
      }.to change { Product.count }.by(1)

      expect(ActionCable.server).to have_received(:broadcast).with(
        "product_updates_#{Digest::MD5.hexdigest(product_url)}",
        {
          status: 'complete',
          product: hash_including(
            'category' => hash_including('name' => 'Audio & Video'),
            'description' => 'Test description',
            'price' => '₹1,599',
            'product_id' => 'test_product_id',
            'seller_name' => 'Test Seller',
            'size' => 'Medium',
            'title' => 'Test Product',
            'url' => 'https://www.example.com/product'
          )
        }
      )
    end
  end

  context 'when scraping fails' do
    before do
      allow_any_instance_of(ProductScraper).to receive(:scrape).and_return(nil)
    end

    it 'broadcasts an error message' do
      expect {
        described_class.perform_now(product_url)
      }.not_to change { Product.count }

      expect(ActionCable.server).to have_received(:broadcast).with(
        "product_updates_#{Digest::MD5.hexdigest(product_url)}",
        hash_including(status: 'error', url: product_url, errors: ['Failed to scrape product'])
      )
    end
  end

  context 'when product data is invalid' do
    before do
      allow_any_instance_of(ProductScraper).to receive(:scrape).and_return(product_data.except(:product_id))
    end

    it 'broadcasts an error message' do
      expect {
        described_class.perform_now(product_url)
      }.not_to change { Product.count }

      expect(ActionCable.server).to have_received(:broadcast).with(
        "product_updates_#{Digest::MD5.hexdigest(product_url)}",
        hash_including(status: 'error', url: product_url, errors: ['Failed to scrape product'])
      )
    end
  end
end
