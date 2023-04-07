require "prawn/measurement_extensions"

module PdfGenerator
  def self.generate(cards)
    pdf = Prawn::Document.new(:page_size => "LETTER", :page_layout => :portrait, print_scaling: :none, margin: 0)
    reset_cursor
    cards.each do |card_image_url, quantity|
      begin
        image = URI.open(card_image_url)
      rescue OpenURI::HTTPError
        next
      end
      quantity.times { add_image_to_pdf(image, pdf) }
    end
    pdf.render
  end

  def self.add_image_to_pdf(image, pdf)
    pdf.image image, width: 2.5.in, at: [@@x_position, @@y_position]
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
