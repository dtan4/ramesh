module Ramesh
  class Client
    MESHES_INDEX_URL = "http://tokyo-ame.jwa.or.jp/scripts/mesh_index.js"

    def initialize(logger)
      @logger = logger
    end

    def download_image(minute, save_dir, filename = nil)
      _download_image(minute, save_dir, filename, :small)
    end

    def download_large_image(minute, save_dir, filename = nil)
      _download_image(minute, save_dir, filename, :large)
    end

    def download_sequential_images(from, to, save_dir)
      raise ArgumentError, "minutes must be a number; 0, 5, 10, ... 120" unless valid_minutes?(from) && valid_minutes?(to)

      [].tap do |image_names|
        (from..to).step(5) { |minute| image_names << download_image(minute, save_dir) }
      end
    end

    private

    def _download_image(minute, save_dir, filename, image_size)
      raise ArgumentError, "minutes must be a number; 0, 5, 10, ... 120" unless valid_minutes?(minute)

      image_name = name_from_minute(minute)
      filename ||= "#{image_name}.jpg"
      image = Image.new(image_name, image_size)
      image.save(save_dir, filename)

      @logger.info("Downloaded: #{filename}")

      filename
    end

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
