# frozen_string_literal: true

# this is shit mailpiece design
# usps will want to kill me
# but it's cute!


module SnailMail
  module Components
    module Templates
      class SummerOfMakingFulfillmentTemplate < TemplateBase
        def self.template_name
          "summer of making fulfillment"
        end

        def self.template_description
          "awawawawa"
        end

        def self.show_on_single? = true


        def view_template

          image(
            image_path("som/explorers.png"),
            at: [189-30, 115+30],
            width: 300,
            )
          # Render return address
          render_return_address(10, 278, 260, 70, size: 10)
          render_destination_address(
            126,
            201+20,
            266,
            67,
            size: 16,
            valign: :bottom,
            align: :left
          )



          # Render postal elements
          render_imb(124, 120+20, 200)
          render_qr_code(5, 65, 60)
          render_letter_id(10, 19, 10)

            bounding_box [150, 278],
                         width: 220,
                         height: 40,
                         valign: :bottom do
              font_size 8
              font("comic") { text "it's here!" }
              text "contents:", style: :bold
              text letter.rubber_stamps || ""
            end
          



          render_postage
        end

      end
    end
  end
end
