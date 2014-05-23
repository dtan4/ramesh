module Ramesh
  class Client
    MESHES_INDEX_URL = "http://tokyo-ame.jwa.or.jp/scripts/mesh_index.js"

    def initialize(logger)
      @logger = logger
    end

    def download_image(save_dir, minute = 0)
      unless valid_minutes?(minute)
        raise ArgumentError, "minutes must be a number; 0, 5, 10, ... 120"
      end

      image_name = name_from_minute(minute)
      image = Image.new(image_name, background_image, mask_image)
      image.save(save_dir, image_name)

      @logger.info("Downloaded: #{image_name}.jpg")
    end

    def download_sequential_images(save_dir, from, to)
      unless valid_minutes?(from) && valid_minutes?(to)
        raise ArgumentError, "minutes must be a number; 0, 5, 10, ... 120"
      end

      (from..to).step(5) do |minute|
        download_image(save_dir, minute)
      end
    end

    private

    def background_image
      @background_image ||= Image.background_image
    end

    def mask_image
      @mask_image ||= Image.mask_image
    end

    def meshes_index
      @meshes_index ||= open(MESHES_INDEX_URL).read.gsub(/[^0-9,]/, "").split(",")
    end

    def name_from_minute(minute)
      meshes_index[minute / 5]
    end

    def valid_minutes?(minutes)
      (minutes >= 0) && (minutes <= 120) && (minutes % 5 == 0)
    end
  end
end
