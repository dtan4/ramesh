module Ramesh
  class Logger
    def initialize(output)
      @output = output
    end

    def info(msg)
      @output.puts msg
    end
  end
end
