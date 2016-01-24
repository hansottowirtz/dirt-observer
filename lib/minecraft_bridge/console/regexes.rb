module MinecraftBridge
  class Console
    module Regexes
      I_USERNAME = /[a-zA-Z0-9_]{1,16}/
      I_IP = /(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])/
      I_IP_WITH_PORT = /#{I_IP.source}:\d{1,5}/
      I_ENTITY_ID = /\d{1,16}/ # dunno
      I_UUID = /[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/

      I_FLOAT = /[-+]?([0-9]*\.[0-9]+|[0-9]+)/

      USERNAME = /^#{I_USERNAME.source}$/
      IP = /^#{I_IP.source}$/
      IP_WITH_PORT = /^#{I_IP_WITH_PORT.source}$/
      ENTITY_ID = /^#{I_ENTITY_ID.source}$/
      UUID = /^#{I_UUID.source}$/

      JOINED_THE_GAME = /^(#{I_USERNAME.source}) joined the game$/
      LEFT_THE_GAME = /^(#{I_USERNAME.source}) left the game$/
      LOGGED_IN = /^(#{I_USERNAME.source})\[\/(#{I_IP_WITH_PORT.source})\] logged in with entity id (#{I_ENTITY_ID.source}) at \(#{I_FLOAT.source}, #{I_FLOAT.source}, #{I_FLOAT.source}\)$/
      LOST_CONNECTION = /^(#{I_USERNAME.source}) lost connection: TextComponent{(.+)}$/

      NORMAL_MESSAGE = /^<(#{I_USERNAME.source})> (.+)$/
      ME_MESSAGE = /^\* (#{I_USERNAME.source}) (.+)$/
      SAY_MESSAGE = /^\[(#{I_USERNAME.source})\] (.+)$/

      SERVER_STARTING_VERSION = /^Starting minecraft server version (\d+.\d+.\d+)$/
      SERVER_STARTING_PORT = /^Starting Minecraft server on \*:(\d{1,5})$/
      SERVER_PREPARING_LEVEL = /^Preparing level "(.+)"$/
      SERVER_PREPARING_START_REGION = /^Preparing start region for level (\d)$/
      SERVER_GAMETYPE = /^Default game type: (\w+)$/
      SERVER_START_DONE = /^Done \((\d+,\d+)s\)! For help, type "help" or "\?"$/
      SERVER_PREPARING_SPAWN = /^Preparing spawn area: (\d{1,2})%$/
      SERVER_GENERATING_KEYPAIR = /^Generating keypair$/
      SERVER_LOADING_PROPERTIES = /^Loading properties$/
      SERVER_CHANNEL_TYPE = /^Using default channel type$/
      SERVER_STOPPING_THE_SERVER = /^Stopping the server$/
      SERVER_STOPPING_SERVER = /^Stopping server$/
      SERVER_SAVING_PLAYERS = /^Saving players$/
      SERVER_SAVING_WORLDS = /^Saving worlds$/
      SERVER_SAVING_CHUNKS = /^Saving chunks for level '(.+)'\/(.+)$/

      USER_AUTHENTICATOR_UUID = /^UUID of player (#{I_USERNAME.source}) is (#{I_UUID.source})$/

      def self.select_regex(text, regexes)
        regexes.each do |regex|
          if text =~ regex
            return regex
          end
        end
        return nil
      end
    end
  end
end
