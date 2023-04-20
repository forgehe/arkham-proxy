require "prawn/measurement_extensions"
require 'open-uri'

module PdfGenerator
  def self.generate(cards)
    pdf = Prawn::Document.new(:page_size => "LETTER", :page_layout => :portrait, print_scaling: :none, margin: 0)
    reset_cursor
    cards.each do |card|
      card[:quantity].times { add_image_to_pdf(pdf, card[:card_image], card[:rotation]) }
    end
    pdf.render
  end

  def self.add_image_to_pdf(pdf, img_url, rotation)
    if rotation
      pdf.rotate(90, origin: [@@x_position, @@y_position]) do  
        pdf.image URI.open(img_url), height: 2.495.in, at: [@@x_position-3.5.in, @@y_position]
      end
    else
      pdf.image URI.open(img_url), width: 2.495.in, at: [@@x_position, @@y_position]
    end
    if ((@@x_position += 2.5.in) > 6.in)
      @@x_position = 0.5.in
      if ((@@y_position -= 3.5.in) < 1.5.in)
        @@y_position = 10.75.in
        pdf.start_new_page
      end
    end

  end

  def self.reset_cursor
    @@y_position = 10.75.in
    @@x_position = 0.5.in
  end
end
