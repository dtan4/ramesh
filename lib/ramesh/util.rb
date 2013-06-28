require 'open-uri'
require 'time'

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

  def format_date_str(date_str)
    if date_str =~ /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})/
      year, month, day, hour, minute = *(Regexp.last_match[1..-1])

      begin
        t = Time.parse(date_str)
        "#{year}-#{month}-#{day} #{hour}:#{minute}"
      rescue ArgumentError
        nil
      end
    else
      nil
    end
  end
end
