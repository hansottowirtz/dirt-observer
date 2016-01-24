module MinecraftBridge
  class Server
    @started = false

    attr_reader :path
    attr_reader :state

    def initialize(path)
      puts "Setting Minecraft server jar path: #{path}".colorize(:green)
      if path == nil || path == ''
        raise StandardError, 'No path provided'
      end
      self.path = path

      MinecraftBridge.add_server self
    end

    def started?
      @state == 'started'
    end

    def on?
      !!@on
    end

    def off?
      !@on
    end

    def executable
      File.basename @path        # => "xyz.mp4"
    end

    def folder
      File.dirname @path        # => "/path/to"
    end

    def path=(path)
      if !on?
        if File.file? path
          valid = MinecraftBridge::Util.valid_minecraft_jar?(path)
          if valid == true
            @path = path
          else
            raise StandardError, "File is not a valid Minecraft server jar: #{path} (#{valid})"
          end
        else
          raise StandardError, "File does not exist: #{path}"
        end
      else
        raise StandardError, 'Server has already started'
      end
    end

    # @folder = '/Users/Otto/Programming/Minecraft/how-minecraft'
    # @executable = 'minecraft_server.jar'

    def start
      if off?
        cmd = "cd #{folder} && java -Xmx1024M -Xms1024M -jar #{executable} nogui"
        puts "Starting a PTY:"
        puts cmd.colorize(:green)

        begin
          @console = MinecraftBridge::Console.new
          @readio, @writeio, @pid = PTY.spawn(cmd)
          @on = true
          set_state 'waiting'

          begin
            @thread = Thread.new do
              @readio.each do |line_text|
                line = @console.process(line_text)
                process_line(line) # Find info about the server in the line
              end
            end
          rescue Errno::EIO
            stop
          end
          puts "PID: #{@pid}"

          puts "\n== Console ==\n "
        rescue PTY::ChildExited => e
          puts 'Child Exited'.green
          stop
        end

      end
    end

    def stop(put_stop = true)
      # Input /stop to Minecraft console
      # Stop the IOs
      # Kill the pid

      if @writeio
        if !@writeio.closed?
          if put_stop
            @writeio.puts '/stop'
          end
          WaitUtil.wait_for_condition("pid to have stopped", timeout_sec: 20, delay_sec: 0.5, verbose: true) do
            !MinecraftBridge::Util.pid_alive?(@pid) || @state == 'stopped'
          end
          puts 'Closing writeio'.green
          @writeio.close
          sleep 1
        end
        if !@readio.closed?
          @readio.close
        end
      end

      sleep 1
      if MinecraftBridge::Util.pid_alive?(@pid)
        begin
          Process.kill 0, @pid
        rescue Errno::ESRCH
        end
      end
      Thread.kill @thread
      @on = false
    end

    def process_line(line)
      if line.category == 'info'
        if line.subcategory == 'server_starting_version'
          puts "Server state: starting".green
          set_state 'starting'
        elsif line.subcategory == 'server_start_done'
          puts "Server state: started".green
          set_state 'started'
        end
      end
      if line.category == 'info' || line.category == 'shutdown'
        if line.subcategory == 'server_stopping_the_server' || line.subcategory == 'server_stopping_server'
          puts "Server state: stopping".green
          set_state 'stopping'
        end
      end
      if line.category == 'shutdown'
        if line.subcategory == 'server_stopping_server'
          puts "Server state: stopped".green
          sleep 1 # just to be sure
          set_state 'stopped'
        end
      end
    end

    private
    def set_state(state)
      @state = state
    end
  end
end
