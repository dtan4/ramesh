require "RMagick"
require "open-uri"

module Ramesh
  class Image
    MESH_URL_BASE = "http://tokyo-ame.jwa.or.jp/mesh/000/"
    BACKGROUND_IMAGE_URL = "http://tokyo-ame.jwa.or.jp/map/map000.jpg"
    MASK_IMAGE_URL = "http://tokyo-ame.jwa.or.jp/map/msk000.png"

    def self.background_image
      download_image(BACKGROUND_IMAGE_URL)
    end

    def self.mask_image
      download_image(MASK_IMAGE_URL)
    end

    def initialize(image_name,
                   background_image = self.class.background_image,
                   mask_image = self.class.mask_image)
      image_list = [
                    background_image,
                    self.class.download_image(moment_image_url(image_name)),
                    mask_image
                   ]
      @image = composite_images(image_list)
    end

    def save(save_dir, image_name)
      save_path = File.join(save_dir, "#{image_name}.jpg")
      @image.write(save_path)
    end

    private

    def self.download_image(url)
      Magick::Image.from_blob(open(url).read).shift
    end

    def moment_image_url(image_name)
      "#{MESH_URL_BASE}#{image_name}.jpg"
    end

    def composite_images(image_list)
      image = image_list.shift
      image_list.each { |layer| image = image.composite(layer, 0, 0, Magick::OverCompositeOp) }
      image
    end
  end
end
