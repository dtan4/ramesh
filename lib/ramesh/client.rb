module Ramesh
  class Client
    MESHES_INDEX_URL = "http://tokyo-ame.jwa.or.jp/scripts/mesh_index.js"

    def download_image(save_dir, minutes = 0)
      unless valid_minutes?(minutes)
        raise ArgumentError, "minutes must be a number; 0, 5, 10, ... 120"
      end

      image_name = meshes_index[minutes / 5]
      image = Image.new(image_name)
      image.save(save_dir, image_name)
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

    def meshes_index
      @meshes_index ||= open(MESHES_INDEX_URL).read.gsub(/[^0-9,]/, "").split(",")
    end

    def valid_minutes?(minutes)
      (minutes >= 0) && (minutes <= 120) && (minutes % 5 == 0)
    end
  end
end
