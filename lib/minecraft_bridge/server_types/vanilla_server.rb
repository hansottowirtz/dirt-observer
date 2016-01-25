module MinecraftBridge
  class VanillaServer
    include MinecraftBridge::Server

    def initialize(path)
      @path = path
    end

    class Console
      include MinecraftBridge::Server::Console

      module Regexes
        include MinecraftBridge::Server::Console::Regexes
        LINE_TEXT = /\[(\d{2}):(\d{2}):(\d{2})\] \[(.+)\]: (.+)/
      end

      module Processor
        extend MinecraftBridge::Server::Console::Processor

        class Line
          include MinecraftBridge::Server::Console::Processor::Line
        end

      end

    end
  end
end
