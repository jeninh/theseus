module SnailMail
  module Templates
    class SummerOfMakingFreeStickersTemplate < BaseTemplate
      def self.template_name
        "SoM Free Stickers"
      end

      def self.show_on_single?
        true
      end

      def render(pdf, letter)
        render_return_address(pdf, letter, 5, pdf.bounds.top - 5, 190, 90, size: 8, font: "f25")
        
        render_destination_address(
          pdf,
          letter,
          120,
          115,
          270,
          81,
          { size: 18, valign: :center, align: :left }
        )

        pdf.image(
          image_path("som/banner.png"),
          at: [-5, 288 - 56],
          width: 445,
        )

        render_imb(pdf, letter, 245, 20, 170)
        render_letter_id(pdf, letter, 3, 15, 8, rotate: 90)
        render_qr_code(pdf, letter, 2, 52, 50)
        render_postage(pdf, letter)
      end
    end
  end
end
