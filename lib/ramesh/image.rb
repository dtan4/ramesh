require "mini_magick"
require "open-uri"

module Ramesh
  class Image
    MESH_URL_BASE = "http://tokyo-ame.jwa.or.jp/mesh"
    MAP_URL_BASE = "http://tokyo-ame.jwa.or.jp/map"

    def initialize(image_name, image_size = :small)
      image_list = [
                    background_image(image_size),
                    moment_image(image_name, image_size),
                    mask_image(image_size)
                   ]
      @image = composite_images(image_list)
    end

    def save(save_dir, filename)
      save_path = File.join(save_dir, filename)
      @image.write(save_path)
    end

    private

    def background_image(image_size)
      download_image(background_image_url(image_size))
    end

    def moment_image(image_name, image_size)
      download_image(moment_image_url(image_name, image_size))
    end

    def mask_image(image_size)
      download_image(mask_image_url(image_size))
    end

    def download_image(url)
      MiniMagick::Image.read(URI.open(url).read)
    end

    def size_number(image_size)
      case image_size
      when :small
        "000"
      when :large
        "100"
      else
        raise ArgumentError, "Invalid size is given"
      end
    end

    def background_image_url(image_size)
      "#{MAP_URL_BASE}/map#{size_number(image_size)}.jpg"
    end

    def moment_image_url(image_name, image_size)
      "#{MESH_URL_BASE}/#{size_number(image_size)}/#{image_name}.gif"
    end

    def mask_image_url(image_size)
      "#{MAP_URL_BASE}/msk#{size_number(image_size)}.png"
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
