module Ramesh
  class Client
    include Util

    def initialize
      @indexes = get_mesh_indexes
    end

    def download_sequential_image(minute_range)
      range = minute_range.split('-').map { |num| num.to_i }.sort

      unless range.length == 2
        $stderr.puts "error: invalid range"
        exit 1
      end

      range.each do |min|
        unless validate_minutes(min)
          $stderr.puts "error: minutes must be a number; 0, 5, 10, ... 120"
          exit 1
        end
      end

      minute = range[0]

      while minute <= range[1]
        download_moment_image(minute)
        minute += 5
      end
    end

    def download_moment_image(minutes = 0)
      unless validate_minutes(minutes)
        $stderr.puts "error: minutes must be a number; 0, 5, 10, ... 120"
        exit 1
      end

      download_index = @indexes[minutes / 5]
      create_moment_image("#{download_index}.gif")

      puts "Successfully downloaded: #{download_index}.gif"
    end
  end
end
