module MinecraftBridge
  class SpigotServer
    include MinecraftBridge::Server

    def initialize(path)
      @path = path
    end

    module Console
      extend MinecraftBridge::Server::Console

      module Regexes
        extend MinecraftBridge::Server::Console::Regexes
        LINE_TEXT = /\[(\d{2}):(\d{2}):(\d{2}) (.+)\]: (.+)/
      end

      module Processor
        extend MinecraftBridge::Server::Console::Processor
      end

    end
  end
end
