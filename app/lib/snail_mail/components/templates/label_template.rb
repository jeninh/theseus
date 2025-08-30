# frozen_string_literal: true

module SnailMail
  module Components
    module Templates
      class LabelTemplate < TemplateBase
        def self.template_name
          "Label Template"
        end

        def self.template_description
          "A basic label template for mail.hackclub.com"
        end

        def view_template
          # Background or main image can be added here when available
          # image(
          #   image_path("label_background.png"),
          #   at: [0, 288],
          #   width: 432,
          # )

          # Render return address in upper left
          render_return_address(10, 278, 146, 70, font: "f25")

          # Render destination address in center-right area
          render_destination_address(
            220,
            180,
            200,
            80,
            size: 16, valign: :center, align: :left
          )

          # Render IMb barcode
          render_imb(216, 25, 207)

          # Render letter ID
          render_letter_id(10, 19, 10)
          
          # Render QR code for tracking
          render_qr_code(5, 55, 50)

          # Render postage
          render_postage
        end
      end
    end
  end
end