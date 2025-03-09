class ProductUpdatesChannel < ApplicationCable::Channel
  def subscribed
    product_url = params[:product_url]
    stream_from "product_updates_#{Digest::MD5.hexdigest(product_url)}"
  end

  def unsubscribed
  end
end
