task add_default_image: :environment do
  # Define the default image URL
  default_image_url = "https://i5.walmartimages.com/seo/Fresh-Banana-Fruit-Each_5939a6fa-a0d6-431c-88c6-b4f21608e4be.f7cd0cc487761d74c69b7731493c1581.jpeg?odnHeight=768&odnWidth=768&odnBg=FFFFFF"

  # Iterate through all products
  Product.find_each do |product|
    unless product.image.attached?
      # Download the image from the URL and attach it
      io = URI.open(default_image_url)
      product.image.attach(io: io, filename: "banana.avif", content_type: "image/avif")
      puts "Attached default image to product #{product.id}"
    end
  end

  puts "Completed adding default images to products."
end
