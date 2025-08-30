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
          # Background image from CDN
          image(
            "https://hc-cdn.hel1.your-objectstorage.com/s/v3/ca3b3b1f406c0644887f743fbd5dd0fd86ebfeba_image.png",
            at: [0, 288],
            width: 432,
          )

          # Render return address in upper left corner (smaller for labels)
          render_return_address(8, 270, 140, 60, font: "f25", size: 8)

          # Render destination address in center area (main focus for labels)
          render_destination_address(
            81,
            190,
            270,
            90,
            size: 18, valign: :center, align: :center
          )

          # Render IMb barcode at bottom (standard position)
          render_imb(150, 25, 270)

          # Render QR code and letter ID in bottom open space
          render_qr_code(300, 50, 45)
          render_letter_id(360, 35, 8)

          # Render postage (top right corner)
          render_postage
        end
      end
    end
  end
end