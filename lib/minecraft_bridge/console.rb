require 'minecraft_bridge/console/regexes'
require 'minecraft_bridge/console/processor'
require 'minecraft_bridge/console/line'

module MinecraftBridge
  class Console
    attr_reader :server
    attr_reader :log

    def initialize
      @log = []
      @server = server
      @processor = MinecraftBridge::Console::Processor.new
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
