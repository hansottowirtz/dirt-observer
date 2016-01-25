require 'minecraft_bridge/server/console/regexes'
require 'minecraft_bridge/server/console/processor'

module MinecraftBridge
  module Server
    module Console
      attr_reader :log

      def initialize(regexes)
        @processor ||= self.class::Processor.setup(regexes)
        @log = []
        return self
      end

      def process(line_text)
        line = @processor.process_line(line_text)
        @log << line
        return line
      end

      def tail(n = 10)
        return @log.last(n)
      end

    end
  end
end
