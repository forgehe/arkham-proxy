class ProxyController < ActionController::Base
  def show
  end

  def new
    data = params[:id].match(/(?<deckType>decklist|deck)\/view\/(?<id>\d{2,9})/i)
    # /(?<id>\d{2,9})/ =~ params[:id]
    # /(?<deckType>decklist|deck)/i =~ params[:id]
    puts data
    puts "id: #{data[:id]}, decktype: #{data[:deckType]}"
    cards = card_ids(data[:id], data[:deckType]).transform_keys { |card_id| card_image_url(card_id) }
    send_data PdfGenerator.generate(cards), filename: "cards.pdf"
  rescue
    flash.alert = "Deck not found"
    render :show
  end

  def card_ids(deck_id, deck_type)
    decklist_api = "https://arkhamdb.com/api/public/"
    HTTParty.get(decklist_api + deck_type + deck_id)["slots"].reject {|id, quantity| id == "01000"}
  end

  def deck
    /(?<id>\d+)/ =~ params[:id]
    cards = deck_card_ids(id).transform_keys { |card_id| card_image_url(card_id) }
    send_data PdfGenerator.generate(cards), filename: "cards.pdf"
  rescue
    flash.alert = "Deck not found"
    render :show
  end

  def deck_card_ids(deck_id)
    decklist_api = "https://arkhamdb.com/api/public/deck/"
    HTTParty.get(decklist_api + deck_id)["slots"].reject {|id, quantity| id == "01000"}
  end

  def card_image_url(card_id)
    card_api = "https://arkhamdb.com/api/public/card/"
    "https://arkhamdb.com" + HTTParty.get(card_api + card_id)["imagesrc"]
  end
end
