class ProxyController < ActionController::Base
  def show
  end

  def new
    data = params[:id].match(/(?<deckType>decklist|deck)\/view\/(?<id>\d{2,9})\/?(?<name>.*)/i)
    p data
    p data[:name]
    cards = card_ids(data[:id], data[:deckType]).transform_keys { |card_id| card_image_url(card_id) }
    filename = data[:deckType].casecmp("decklist") ? data[:name] : data[:id]
    send_data PdfGenerator.generate(cards), filename: "#{filename}.pdf"
  rescue
    flash.alert = "Deck not found, is it set to private?"
    render :show
  end

  def card_ids(deck_id, deck_type)
    data = HTTParty.get("https://arkhamdb.com/api/public/#{deck_type}/#{deck_id}")
    output = data["slots"].merge(data["sideSlots"]).reject {|id, quantity| id == "01000"}
    p output
    output
    # HTTParty.get("https://arkhamdb.com/api/public/#{deck_type}/#{deck_id}")["slots"].reject {|id, quantity| id == "01000"}
  end

  def card_image_url(card_id)
    card_image_src = HTTParty.get("https://arkhamdb.com/api/public/card/#{card_id}")["imagesrc"]
    "https://arkhamdb.com#{card_image_src}"
  end
end
