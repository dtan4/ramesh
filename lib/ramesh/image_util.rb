require 'RMagick'
require 'open-uri'

module Ramesh::ImageUtil
  MESH_URL_BASE ='http://tokyo-ame.jwa.or.jp/mesh/000/'
  BACKGROUND_IMAGE_URL = 'http://tokyo-ame.jwa.or.jp/map/map000.jpg'
  MAP_MASK_URL = 'http://tokyo-ame.jwa.or.jp/map/msk000.png'

  include Magick

  def create_animation_gif(indexes, filename)
    gif_list = indexes.map { |index| "#{index}.gif" }
    gif_list.each { |gif| create_moment_image("#{gif}") }

    image_list = ImageList.new(*gif_list)
    image_list.delay = 10
    image_list.iterations = 0
    image_list.write(filename)
  end

  def create_moment_image(filename)
    mesh_url = MESH_URL_BASE + filename

    begin
      image_list = [
                    Image.from_blob(open(BACKGROUND_IMAGE_URL).read).shift,
                    Image.from_blob(open(MAP_MASK_URL).read).shift,
                    Image.from_blob(open(mesh_url).read).shift
                   ]
      moment_image = composite_images(image_list)
      moment_image.write(filename)
    rescue OpenURI::HTTPError
    end
  end

  def composite_images(image_list)
    image = image_list.shift

    (1...image_list.length).each { |i| image = image.composite(image_list[i], 0, 0, OverCompositeOp) }

    image
  end
end
