require 'open-uri'
require 'time'
require 'uri'

module Ramesh::Util
  AMESH_INDEXES_URL = 'http://tokyo-ame.jwa.or.jp/scripts/mesh_index.js'

  def extract_filename(url)
    if url[-1] == "/"
      ""
    else
      File.basename(URI(url).path)
    end
  end

  def get_mesh_indexes
    begin
      indexes_js = open(AMESH_INDEXES_URL).read
      indexes = indexes_js.gsub(/[^0-9,]/, '').split(',')
    rescue
      raise Ramesh::DownloadError, AMESH_INDEXES_URL
    end
  end

  def validate_minutes(minutes)
    (minutes >= 0) && (minutes <= 120) && (minutes % 5 == 0)
  end
end
