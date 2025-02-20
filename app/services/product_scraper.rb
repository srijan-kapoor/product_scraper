require 'watir'

class ProductScraper
  SELECTORS = {
    title: '.mEh187, .VU-ZEz',
    price: '.Nx9bqj.CxhGGd',
    category: '._7dPnhA div',
    seller_name: 'div#sellerName.yeLeBC span span',
    description_main: 'div.cPHDOP.col-12-12 div._4gvKMe div.yN+eNk.w9jEaj',
    description_fallback: 'div.cPHDOP.col-12-12 div._4gvKMe',
    metadata_dropdown: '.col.col-1-12.cWwIYq',
    metadata_keys: '.col.col-3-12._9NUIO9',
    metadata_values: '.col.col-9-12.-gXFvC'
  }

  def initialize(product_url)
    @browser = Watir::Browser.new :chrome, headless: true
    @browser.goto(product_url)
  end

  def scrape
    metadata = extract_metadata
    {
      title: extract_text(:title),
      price: extract_text(:price),
      size: extract_size_from_metadata(metadata),
      category: extract_category,
      seller_name: extract_text(:seller_name),
      description: extract_description,
      metadata: metadata,
      product_id: extract_product_id
    }
  ensure
    @browser.close if @browser
  end

  private

  def extract_text(field)
    with_timeout_fallback { @browser.elements(css: SELECTORS[field]).map(&:text).join(' ').strip } || "#{field.to_s.capitalize} not found"
  end

  def extract_category
    with_timeout_fallback { @browser.elements(css: SELECTORS[:category])[1]&.text&.strip } || 'Category not found'
  end

  def extract_description
    with_timeout_fallback do
      description_element = @browser.element(css: SELECTORS[:description_main])
      description_element.exists? ? description_element.text.strip : @browser.element(css: SELECTORS[:description_fallback]).text.strip
    end || 'Description not found'
  end

  def extract_metadata
    dropdown = @browser.element(css: SELECTORS[:metadata_dropdown])
    dropdown.click if dropdown.exists?
    sleep 1

    keys = with_timeout_fallback { @browser.elements(css: SELECTORS[:metadata_keys]).map(&:text).map(&:strip) } || []
    values = with_timeout_fallback { @browser.elements(css: SELECTORS[:metadata_values]).map(&:text).map(&:strip) } || []

    keys.zip(values).to_h.reject { |k, v| k.empty? }
  end

  def extract_size_from_metadata(metadata)
    size_entry = metadata.find { |k, _| k.downcase.include?('size') }
    size_entry ? size_entry.last : 'N/A'
  end

  def extract_product_id
    @browser.url.split('/p/').last.split('?').first rescue nil
  end

  def with_timeout_fallback(timeout: 10)
    Watir::Wait.until(timeout: timeout) { yield }
  rescue StandardError
    nil
  end
end

# scraper = ProductScraper.new("https://www.flipkart.com/srpm-wayfarer-sunglasses/p/itmaf19ae5820c06").scrape
