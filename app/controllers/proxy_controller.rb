class ProxyController < ActionController::Base
  def show
  end

  def new
    data = params[:id].match(/(?<deckType>decklist|deck)\/view\/(?<id>\d{2,9})\/?(?<name>.*)/i)
    cards = card_ids(data[:id], data[:deckType])
    filename = data[:deckType].casecmp("decklist") == 0 ? data[:name] : data[:id]
    send_data PdfGenerator.generate(cards), filename: "#{filename}.pdf"
  rescue
    flash.alert = "Deck not found, is it set to private?"
    render :show
  end

  def card_ids(deck_id, deck_type)
    data = HTTParty.get("https://arkhamdb.com/api/public/#{deck_type}/#{deck_id}")
    output = (investigator_cards(data["investigator_code"]))
    # output = []
    output.push(*transform_arkhamdb_data(data["slots"]))
    if data.key?("sideSlots") && data["sideSlots"].empty? == false
      output.push(*transform_arkhamdb_data(data["sideSlots"]))
    end
    output
  end

  def investigator_cards(investigator_code)
    output = [
      {
        card_image: card_image_url(investigator_code), 
        quantity: 1, 
        rotation: true
      }, 
      {
        card_image: card_image_url(investigator_code, "backimagesrc"), 
        quantity: 1, 
        rotation: true
      }
    ]
  end

  def card_image_url(card_id, src = "imagesrc")
    data = HTTParty.get("https://arkhamdb.com/api/public/card/#{card_id}")
    p data
    if data.key?(src)
      card_image_src = "https://arkhamdb.com#{data[src]}"
    else
      card_image_src = nil
    end
      card_image_src
  end

  def transform_arkhamdb_data(data)
    output = []
    data = data.reject {|id, quantity| id == "01000"}
    data.each do |card_id, qty|
      obj = {
        card_image: card_image_url(card_id), 
        quantity: qty, 
        rotation: false
      }
      if obj[:card_image]
        output.append(obj)
      end
    end
    output
  end
end
