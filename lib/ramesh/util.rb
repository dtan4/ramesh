require 'open-uri'

module Util
  AMESH_INDEXES_URL = 'http://tokyo-ame.jwa.or.jp/scripts/mesh_index.js'

  def extract_filename(url)
    if url =~ /.+\/([a-zA-Z0-9._-]+)$/
      $1
    else
      ''
    end
  end

  def get_mesh_indexes
    begin
      indexes_js = open(AMESH_INDEXES_URL).read
      indexes = indexes_js.gsub(/[^0-9,]/, '').split(',')
    rescue
      $stderr.puts 'Failed to download: #{AMESH_INDEXES_URL}'
    end
  end
end
