require 'minitest/autorun'
require 'minecraft_bridge'

class TestLine < Minitest::Test
  def setup
    @processor = MinecraftBridge::Console::Processor.new
  end

  def test_get_parts
    puts @processor.get_parts(@random_message).to_s
  end
end
