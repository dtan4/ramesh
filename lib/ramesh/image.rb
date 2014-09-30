require "mini_magick"
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

    def initialize(image_name)
      image_list = [
                    self.class.background_image,
                    self.class.download_image(moment_image_url(image_name)),
                    self.class.mask_image
                   ]
      @image = composite_images(image_list)
    end

    def save(save_dir, filename)
      save_path = File.join(save_dir, filename)
      @image.write(save_path)
    end

    private

    def self.download_image(url)
      MiniMagick::Image.read(open(url).read)
    end

    def moment_image_url(image_name)
      "#{MESH_URL_BASE}#{image_name}.gif"
    end

    def composite_images(image_list)
      image = image_list.shift

      image_list.each do |layer|
        image = image.composite(layer) do |c|
          c.compose "Over"
        end
      end

      image
    end
  end
end
