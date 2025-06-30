module SnailMail
  module Components
    class HalfLetterComponent < TemplateBase
      def self.abstract?
        true
      end
      
      def self.template_size
        :half_letter
      end

      def view_template
        render_front
        start_new_page
        render_back
      end

      # Override in subclasses to define the front content
      def render_front
        raise NotImplementedError, "Subclasses must implement render_front"
      end

      def render_back
        render_postage
        render_imb(bounds.right - 217, 25, 207)
        render_return_address(5, bounds.top - 5, 190, 90, size: 8, font: "f25")
        render_destination_address(
          (bounds.right/2)-256/2,
          (bounds.top/2)+107/2,
          256,
          107,
          size: 18, valign: :center, align: :left
        )
        render_qr_code(2, 52, 50)
      end
    end
  end
end
