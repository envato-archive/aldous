module Aldous
  class StdoutLogger
    class << self
      def info(message)
        $stdout.puts message
      end
    end
  end
end
