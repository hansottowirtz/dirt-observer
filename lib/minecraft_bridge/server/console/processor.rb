require 'minecraft_bridge/server/console/processor/line'

module MinecraftBridge
  module Server
    module Console
      module Processor
        
        def setup(regexes)
          puts "Setting up regexes #{regexes}"
          return self if defined?(@@regexes)

          @@regexes = regexes

          @@info_messages = [
            @@regexes::JOINED_THE_GAME,
            @@regexes::LEFT_THE_GAME,
            @@regexes::LOGGED_IN,
            @@regexes::LOST_CONNECTION,
            @@regexes::NORMAL_MESSAGE,
            @@regexes::SAY_MESSAGE,
            @@regexes::ME_MESSAGE,
            @@regexes::SERVER_STARTING_VERSION,
            @@regexes::SERVER_STARTING_PORT,
            @@regexes::SERVER_PREPARING_LEVEL,
            @@regexes::SERVER_GAMETYPE,
            @@regexes::SERVER_START_DONE,
            @@regexes::SERVER_PREPARING_SPAWN,
            @@regexes::SERVER_PREPARING_START_REGION,
            @@regexes::SERVER_GENERATING_KEYPAIR,
            @@regexes::SERVER_LOADING_PROPERTIES,
            @@regexes::SERVER_CHANNEL_TYPE,
            @@regexes::SERVER_STOPPING_THE_SERVER,
            @@regexes::SERVER_STOPPING_SERVER,
            @@regexes::SERVER_SAVING_PLAYERS,
            @@regexes::SERVER_SAVING_CHUNKS,
            @@regexes::SERVER_SAVING_WORLDS
          ]

          @@warn_messages = [
            @@regexes::SERVER_CANT_KEEP_UP,
            @@regexes::SERVER_TIME_BACKWARDS,
            @@regexes::SERVER_FAILED_PORT,
            @@regexes::SERVER_EXCEPTION,
            @@regexes::SERVER_PERHAPS_ALREADY_RUNNING
          ]

          @@user_authenticator_messages = [
            @@regexes::USER_AUTHENTICATOR_UUID
          ]

          @@watchdog_fatal_messages = [
            @@regexes::SERVER_CANT_KEEP_UP,
            @@regexes::SERVER_TIME_BACKWARDS,
            @@regexes::SERVER_CONSIDERING_CRASHED,
            @@regexes::SERVER_TICK_TIME
          ]

          @@watchdog_error_messages = [
            @@regexes::SERVER_CRASH_REPORT
          ]

          @@shutdown_messages = [
            @@regexes::SERVER_STOPPING_SERVER,
            @@regexes::SERVER_SAVING_PLAYERS,
            @@regexes::SERVER_SAVING_CHUNKS,
            @@regexes::SERVER_SAVING_WORLDS
          ]
          return self
        end

        def process_line(line_text)
          puts line_text

          line = self::Line.new(line_text, @@regexes)

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
          elsif line.caller == 'Server Watchdog/FATAL'
            process_watchdog_fatal_message(line)
            line.category = 'watchdog_fatal'
          elsif line.caller == 'Server Watchdog/ERROR'
            process_watchdog_error_message(line)
            line.category = 'watchdog_error'
          else
            process_unknown_message(line)
            line.category = 'unknown'
          end

          highlight_parse_data(line)

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
          regex = Util.select_regex(line.content, @@info_messages)
          if regex
            md = regex.match(line.content)

            case regex.source
            when @@regexes::JOINED_THE_GAME.source, @@regexes::LEFT_THE_GAME.source
              line.parse_data = {
                player: {from: md.begin(1), to: md.end(1), data: md[1]}
              }
            when @@regexes::LOGGED_IN.source
              line.parse_data = {
                player: {from: md.begin(1), to: md.end(1), data: md[1]},
                ip: {from: md.begin(2), to: md.end(2), data: md[2]},
                entity_id: {from: md.begin(6), to: md.end(6), data: md[6]},
                x: {from: md.begin(7), to: md.end(7), data: md[7]},
                y: {from: md.begin(8), to: md.end(8), data: md[8]},
                z: {from: md.begin(9), to: md.end(9), data: md[9]}
              }
            when @@regexes::LOST_CONNECTION.source
              line.parse_data = {
                player: {from: md.begin(1), to: md.end(1), data: md[1]}
              }
            when @@regexes::NORMAL_MESSAGE.source, @@regexes::SAY_MESSAGE.source, @@regexes::ME_MESSAGE.source
              line.parse_data = {
                player: {from: md.begin(1), to: md.end(1), data: md[1]}
              }
            when @@regexes::SERVER_START_DONE.source
              line.parse_data = {
                boot_time: {from: md.begin(1), to: md.end(1), data: md[1]}
              }
            when @@regexes::SERVER_STARTING_VERSION.source
              line.parse_data = {
                version: {from: md.begin(1), to: md.end(1), data: md[1]}
              }
            when @@regexes::SERVER_STARTING_PORT.source
              line.parse_data = {
                port: {from: md.begin(1), to: md.end(1), data: md[1]}
              }
            when @@regexes::SERVER_PREPARING_LEVEL.source
              line.parse_data = {
                preparing_percentage: {from: md.begin(1), to: md.end(1), data: md[1]}
              }
            end

            case regex.source
            when @@regexes::JOINED_THE_GAME.source
              line.subcategory = 'joined_game'
            when @@regexes::LEFT_THE_GAME.source
              line.subcategory = 'left_game'
            when @@regexes::LOGGED_IN.source
              line.subcategory = 'logged_in'
            when @@regexes::LOST_CONNECTION.source
              line.subcategory = 'lost_connection'
            when @@regexes::NORMAL_MESSAGE.source
              line.subcategory = 'normal_message'
            when @@regexes::SAY_MESSAGE.source
              line.subcategory = 'say_message'
            when @@regexes::ME_MESSAGE.source
              line.subcategory = 'me_message'
            when @@regexes::SERVER_STARTING_VERSION.source
              line.subcategory = 'server_starting_version'
            when @@regexes::SERVER_STARTING_PORT.source
              line.subcategory = 'server_starting_port'
            when @@regexes::SERVER_PREPARING_LEVEL.source
              line.subcategory = 'server_preparing_level'
            when @@regexes::SERVER_PREPARING_START_REGION.source
              line.subcategory = 'server_preparing_start_region'
            when @@regexes::SERVER_GAMETYPE.source
              line.subcategory = 'server_gamemode'
            when @@regexes::SERVER_START_DONE.source
              line.subcategory = 'server_start_done'
            when @@regexes::SERVER_PREPARING_SPAWN.source
              line.subcategory = 'server_preparing_spawn'
            when @@regexes::SERVER_GENERATING_KEYPAIR.source
              line.subcategory = 'server_generating_keypair'
            when @@regexes::SERVER_LOADING_PROPERTIES.source
              line.subcategory = 'server_loading_properties'
            when @@regexes::SERVER_CHANNEL_TYPE.source
              line.subcategory = 'server_channel_type'
            when @@regexes::SERVER_STOPPING_THE_SERVER.source
              line.subcategory = 'server_stopping_the_server'
            when @@regexes::SERVER_STOPPING_SERVER.source
              line.subcategory = 'server_stopping_server'
            when @@regexes::SERVER_SAVING_PLAYERS.source
              line.subcategory = 'server_saving_players'
            when @@regexes::SERVER_SAVING_CHUNKS.source
              line.subcategory = 'server_saving_chunks'
            when @@regexes::SERVER_SAVING_WORLDS.source
              line.subcategory = 'server_saving_worlds'
            else
              line.subcategory = 'unknown'
            end
          end
        end

        def process_warn_message(line)
          regex = Util.select_regex(line.content, @@warn_messages)
          if regex
            md = regex.match(line.content)

            case regex.source
            when @@regexes::SERVER_CANT_KEEP_UP.source
              line.subcategory = 'server_cant_keep_up'
            when @@regexes::SERVER_TIME_BACKWARDS.source
              line.subcategory = 'server_time_backwards'
            when @@regexes::SERVER_FAILED_PORT.source
              line.subcategory = 'server_failed_port'
            when @@regexes::SERVER_EXCEPTION.source
              line.subcategory = 'server_exception'
            when @@regexes::SERVER_PERHAPS_ALREADY_RUNNING.source
              line.subcategory = 'server_perhaps_already_running'
            end
          end
        end

        def process_error_message(line)
        end

        def process_shutdown_message(line)
          regex = Util.select_regex(line.content, @@shutdown_messages)
          if regex
            md = regex.match(line.content)

            case regex.source
            when @@regexes::SERVER_STOPPING_SERVER.source
              line.subcategory = 'server_stopping_server'
            when @@regexes::SERVER_SAVING_PLAYERS.source
              line.subcategory = 'server_saving_players'
            when @@regexes::SERVER_SAVING_CHUNKS.source
              line.subcategory = 'server_saving_chunks'
            when @@regexes::SERVER_SAVING_WORLDS.source
              line.subcategory = 'server_saving_worlds'
            end
          end
        end

        def process_user_authenticator_message(line)
          regex = Util.select_regex(line.content, @@user_authenticator_messages)
          if regex
            md = regex.match(line.content)

            case regex.source
            when @@regexes::USER_AUTHENTICATOR_UUID.source
              line.subcategory = 'player_uuid'
            end
          end
        end

        def process_watchdog_fatal_message(line)
          regex = Util.select_regex(line.content, @@watchdog_fatal_messages)
          if regex
            md = regex.match(line.content)

            case regex.source
            when @@regexes::SERVER_CONSIDERING_CRASHED.source
              line.subcategory = 'server_considering_crashed'
            when @@regexes::SERVER_TICK_TIME.source
              line.subcategory = 'server_tick_time'
            end
          end
        end

        def process_watchdog_error_message(line)
          regex = Util.select_regex(line.content, @@watchdog_error_messages)
          if regex
            md = regex.match(line.content)

            case regex.source
            when @@regexes::SERVER_CRASH_REPORT.source
              line.subcategory = 'server_crash_report'
            end
          end
        end


        def process_unknown_message(line)
          line.parsed_content = line.content
        end

        def highlight_parse_data(line)
          line.parsed_content = line.content
          if line.parse_data
            Hash[line.parse_data.to_a.reverse].each do |key, value|
              line.parsed_content.insert(value[:to], "\e[22m")
              line.parsed_content.insert(value[:from], "\e[1m")
            end
          end
        end
      end
    end
  end
end
