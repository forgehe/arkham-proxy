class ProxyController < ActionController::Base
  def show
  end

  def new
    data = params[:id].match(/(?<deckType>decklist|deck)\/view\/(?<id>\d{2,9})/i)
    cards = card_ids(data[:id], data[:deckType]).transform_keys { |card_id| card_image_url(card_id) }
    send_data PdfGenerator.generate(cards), filename: "cards.pdf"
  rescue
    flash.alert = "Deck not found, is it set to private?"
    render :show
  end

  def card_ids(deck_id, deck_type)
    HTTParty.get("https://arkhamdb.com/api/public/#{deck_type}/#{deck_id}")["slots"].reject {|id, quantity| id == "01000"}
  end

  def card_image_url(card_id)
    card_image_src = HTTParty.get("https://arkhamdb.com/api/public/card/#{card_id}")["imagesrc"]
    "https://arkhamdb.com#{card_image_src}"
  end
end
