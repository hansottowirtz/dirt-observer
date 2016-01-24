require 'minitest/autorun'
require 'minecraft_bridge'

class TestProcessor < Minitest::Test
  def setup
    @random_message = '[22:18:45] [Server thread/INFO]: CloudDust01 left the game'
    @processor = MinecraftBridge::Console::Processor.new
    @message_file = File.open("#{MinecraftBridge.root}/test/fixtures/console.txt").read
  end

  def test_get_process_line
    # @processor.process_line @random_message

    @message_file.split("\n").each do |line|
      @processor.process_line line
    end
  end
end
