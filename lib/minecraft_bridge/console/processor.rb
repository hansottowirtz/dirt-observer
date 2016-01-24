module MinecraftBridge
  class Console
    class Processor
      Regexes = MinecraftBridge::Console::Regexes

      INFO_MESSAGES = [
        Regexes::JOINED_THE_GAME,
        Regexes::LEFT_THE_GAME,
        Regexes::LOGGED_IN,
        Regexes::LOST_CONNECTION,
        Regexes::NORMAL_MESSAGE,
        Regexes::SAY_MESSAGE,
        Regexes::ME_MESSAGE,
        Regexes::SERVER_STARTING_VERSION,
        Regexes::SERVER_STARTING_PORT,
        Regexes::SERVER_PREPARING_LEVEL,
        Regexes::SERVER_GAMETYPE,
        Regexes::SERVER_START_DONE,
        Regexes::SERVER_PREPARING_SPAWN,
        Regexes::SERVER_PREPARING_START_REGION,
        Regexes::SERVER_GENERATING_KEYPAIR,
        Regexes::SERVER_LOADING_PROPERTIES,
        Regexes::SERVER_CHANNEL_TYPE,
        Regexes::SERVER_STOPPING_THE_SERVER,
        Regexes::SERVER_STOPPING_SERVER,
        Regexes::SERVER_SAVING_PLAYERS,
        Regexes::SERVER_SAVING_CHUNKS,
        Regexes::SERVER_SAVING_WORLDS
      ]

      USER_AUTHENTICATOR_MESSAGES = [
        Regexes::USER_AUTHENTICATOR_UUID
      ]

      SHUTDOWN_MESSAGES = [
        Regexes::SERVER_STOPPING_SERVER,
        Regexes::SERVER_SAVING_PLAYERS,
        Regexes::SERVER_SAVING_CHUNKS,
        Regexes::SERVER_SAVING_WORLDS
      ]

      def process_line(line_text)
        puts ''
        puts line_text

        line = MinecraftBridge::Console::Line.new(line_text)

        return line if line.invalid

        if line.caller == 'Server thread/INFO'
          process_info_message(line)
          line.category = 'info'
        elsif line.caller == 'Server thread/WARN'
          process_warn_message(line)
          line.category = 'warn'
        elsif line.caller == 'Server thread/ERROR'
          process_error_message(line)
          line.category = 'error'
        elsif line.caller =~ /User Authenticator #\d{1,2}\/INFO/
          process_user_authenticator_message(line)
          line.category = 'user_authenticator'
        elsif line.caller == 'Server Shutdown Thread/INFO'
          process_shutdown_message(line)
          line.category = 'shutdown'
        else
          process_unknown_message(line)
          line.category = 'unknown'
        end

        if !line.category
          line.category = 'unknown'
        end

        if !line.subcategory
          line.subcategory = 'unknown'
        end

        puts "#{line.category} -- #{line.subcategory}".colorize(:light_blue)
        puts line.parsed_content #.colorize(:light_black)

        # puts 'process_line done'
        return line
      end

      def process_info_message(line)
        text = line.content

        regex = Regexes.select_regex(text, INFO_MESSAGES)
        if regex

          md = regex.match(text)

          case regex.source
          when Regexes::JOINED_THE_GAME.source, Regexes::LEFT_THE_GAME.source
            line.parse_data = {
              player: {from: md.begin(1), to: md.end(1), data: md[1]}
            }
          when Regexes::LOGGED_IN.source
            line.parse_data = {
              player: {from: md.begin(1), to: md.end(1), data: md[1]},
              ip: {from: md.begin(2), to: md.end(2), data: md[2]},
              entity_id: {from: md.begin(6), to: md.end(6), data: md[6]},
              x: {from: md.begin(7), to: md.end(7), data: md[7]},
              y: {from: md.begin(8), to: md.end(8), data: md[8]},
              z: {from: md.begin(9), to: md.end(9), data: md[9]}
            }
          when Regexes::LOST_CONNECTION.source
            line.parse_data = {
              player: {from: md.begin(1), to: md.end(1), data: md[1]}
            }
          when Regexes::NORMAL_MESSAGE.source, Regexes::SAY_MESSAGE.source, Regexes::ME_MESSAGE.source
            line.parse_data = {
              player: {from: md.begin(1), to: md.end(1), data: md[1]}
            }
          when Regexes::SERVER_START_DONE.source
            line.parse_data = {
              boot_time: {from: md.begin(1), to: md.end(1), data: md[1]}
            }
          when Regexes::SERVER_STARTING_VERSION.source
            line.parse_data = {
              version: {from: md.begin(1), to: md.end(1), data: md[1]}
            }
          when Regexes::SERVER_STARTING_PORT.source
            line.parse_data = {
              port: {from: md.begin(1), to: md.end(1), data: md[1]}
            }
          when Regexes::SERVER_PREPARING_LEVEL.source
            line.parse_data = {
              preparing_percentage: {from: md.begin(1), to: md.end(1), data: md[1]}
            }
          end

          Hash[line.parse_data.to_a.reverse].each do |key, value|
            text.insert(value[:to], "\e[22m")
            text.insert(value[:from], "\e[1m")
          end

          case regex.source
          when Regexes::JOINED_THE_GAME.source
            line.subcategory = 'joined_game'
          when Regexes::LEFT_THE_GAME.source
            line.subcategory = 'left_game'
          when Regexes::LOGGED_IN.source
            line.subcategory = 'logged_in'
          when Regexes::LOST_CONNECTION.source
            line.subcategory = 'lost_connection'
          when Regexes::NORMAL_MESSAGE.source
            line.subcategory = 'normal_message'
          when Regexes::SAY_MESSAGE.source
            line.subcategory = 'say_message'
          when Regexes::ME_MESSAGE.source
            line.subcategory = 'me_message'
          when Regexes::SERVER_STARTING_VERSION.source
            line.subcategory = 'server_starting_version'
          when Regexes::SERVER_STARTING_PORT.source
            line.subcategory = 'server_starting_port'
          when Regexes::SERVER_PREPARING_LEVEL.source
            line.subcategory = 'server_preparing_level'
          when Regexes::SERVER_PREPARING_START_REGION.source
            line.subcategory = 'server_preparing_start_region'
          when Regexes::SERVER_GAMETYPE.source
            line.subcategory = 'server_gamemode'
          when Regexes::SERVER_START_DONE.source
            line.subcategory = 'server_start_done'
          when Regexes::SERVER_PREPARING_SPAWN.source
            line.subcategory = 'server_preparing_spawn'
          when Regexes::SERVER_GENERATING_KEYPAIR.source
            line.subcategory = 'server_generating_keypair'
          when Regexes::SERVER_LOADING_PROPERTIES.source
            line.subcategory = 'server_loading_properties'
          when Regexes::SERVER_CHANNEL_TYPE.source
            line.subcategory = 'server_channel_type'
          when Regexes::SERVER_STOPPING_THE_SERVER.source
            line.subcategory = 'server_stopping_the_server'
          when Regexes::SERVER_STOPPING_SERVER.source
            line.subcategory = 'server_stopping_server'
          when Regexes::SERVER_SAVING_PLAYERS.source
            line.subcategory = 'server_saving_players'
          when Regexes::SERVER_SAVING_CHUNKS.source
            line.subcategory = 'server_saving_chunks'
          when Regexes::SERVER_SAVING_WORLDS.source
            line.subcategory = 'server_saving_worlds'
          else
            line.subcategory = 'unknown'
          end
        end

        line.parsed_content = text
      end

      def process_warn_message(line)
        line.parsed_content = line.content
      end

      def process_error_message(line)
        line.parsed_content = line.content
      end

      def process_shutdown_message(line)
        text = line.content

        regex = Regexes.select_regex(text, SHUTDOWN_MESSAGES)
        if regex

          md = regex.match(text)

          case regex.source
          when Regexes::SERVER_STOPPING_SERVER.source
            line.subcategory = 'server_stopping_server'
          when Regexes::SERVER_SAVING_PLAYERS.source
            line.subcategory = 'server_saving_players'
          when Regexes::SERVER_SAVING_CHUNKS.source
            line.subcategory = 'server_saving_chunks'
          when Regexes::SERVER_SAVING_WORLDS.source
            line.subcategory = 'server_saving_worlds'
          end

          # if line.parse_data
          #   Hash[line.parse_data.to_a.reverse].each do |key, value|
          #     text.insert(value[:to], "\e[22m")
          #     text.insert(value[:from], "\e[1m")
          #   end
          # end
        end

        line.parsed_content = text
      end

      def process_user_authenticator_message(line)
        text = line.content

        regex = Regexes.select_regex(text, USER_AUTHENTICATOR_MESSAGES)
        if regex

          md = regex.match(text)

          case regex.source
          when Regexes::USER_AUTHENTICATOR_UUID.source
            line.subcategory = 'player_uuid'
          end

          if line.parse_data
            Hash[line.parse_data.to_a.reverse].each do |key, value|
              text.insert(value[:to], "\e[22m")
              text.insert(value[:from], "\e[1m")
            end
          end
        end

        line.parsed_content = text
      end

      def process_unknown_message(line)
        line.parsed_content = line.content
      end
    end
  end
end
