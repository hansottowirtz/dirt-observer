require 'active_support/core_ext/date/conversions'

module MinecraftBridge
  module Server
    module Console
      module Processor
        module Line
          attr_reader :time
          attr_reader :caller
          attr_reader :content

          attr_reader :time_offset

          attr_accessor :category
          attr_accessor :subcategory
          attr_accessor :parsed_content
          attr_accessor :parse_data
          attr_reader   :original_content
          attr_reader   :invalid

          def initialize(line_text, regexes)
            line_text = line_text.strip

            md = regexes::LINE_TEXT.match(line_text)
            # [10:07:19 INFO]: Server Ping Player Sample Count: 12
            # /\[(\d{2}):(\d{2}):(\d{2})\] \[(.+)\]: (.+)/
            @original_content = line_text

            if !md
              puts 'No valid Minecraft console text, must be from console'
              @invalid = true
            else
              @invalid = false
              now = DateTime.now
              @time = DateTime.new(now.year, now.month, now.day, md[1].to_i, md[2].to_i, md[3].to_i)
              @time_offset = ((now - time) * 24 * 60 * 60).to_i # in seconds
              @caller = md[4]
              @content = md[5].strip
            end
            
          end

        end
      end
    end
  end
end
