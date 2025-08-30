# Label Template

A basic label template for mail.hackclub.com that provides a clean, optimized layout for shipping labels.

## Features

- **Optimized Layout**: Designed specifically for standard 4x6 inch labels
- **Centered Destination Address**: Main focus with larger text for readability
- **Compact Elements**: Smaller return address and QR code to maximize space
- **Standard Compliance**: Includes all required USPS elements (IMB barcode, postage, etc.)
- **Single Selection Ready**: Available in template picker for individual use

## Usage

The template is automatically discoverable by the system and will appear in the template picker with the name "Label Template".

### Positioning Details

- **Return Address**: Top-left corner (8, 270, 140x60) with size 8 font
- **Destination Address**: Center area (150, 190, 270x90) with size 18 font
- **IMB Barcode**: Bottom center (150, 25, 270 width)
- **QR Code**: Left side (8, 90, 45x45) for tracking
- **Letter ID**: Bottom-left (8, 15) with size 8 font
- **Postage**: Top-right corner (standard position)

## Customization

To add a background image or customize the layout:

1. Add your image to `app/lib/snail_mail/assets/images/`
2. Uncomment and modify the image section in `view_template`
3. Adjust positioning coordinates as needed

Example:
```ruby
image(
  image_path("your_label_background.png"),
  at: [0, 288],
  width: 432,
)
```

## Template Structure

The template follows the standard Hack Club mail template pattern:
- Extends `TemplateBase`
- Located in `app/lib/snail_mail/components/templates/`
- Auto-discovered by `SnailMail::Components::Registry`
- Uses standard render methods for consistent formatting