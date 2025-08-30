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

        def self.show_on_single?
          true
        end

        def view_template
          # Background or main image can be added here when available
          # image(
          #   image_path("label_background.png"),
          #   at: [0, 288],
          #   width: 432,
          # )

          # Render return address in upper left corner (smaller for labels)
          render_return_address(8, 270, 140, 60, font: "f25", size: 8)

          # Render destination address in center area (main focus for labels)
          render_destination_address(
            150,
            190,
            270,
            90,
            size: 18, valign: :center, align: :left
          )

          # Render IMb barcode at bottom (standard position)
          render_imb(150, 25, 270)

          # Render letter ID (smaller, bottom left)
          render_letter_id(8, 15, 8)
          
          # Render QR code for tracking (smaller, left side)
          render_qr_code(8, 90, 45)

          # Render postage (top right corner)
          render_postage
        end
      end
    end
  end
end