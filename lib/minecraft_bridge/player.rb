module MinecraftBridge
  class Player
    attr_reader :username
    attr_reader :uuid

    def initialize(uuid)
      if uuid =~ MinecraftBridge::Console::Regexes::UUID
        @uuid = uuid
      else
        raise StandardError, 'No valid UUID'
      end
    end

    
  end
end
