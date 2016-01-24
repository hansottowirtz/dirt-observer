require 'minitest/autorun'
require 'minecraft_bridge'

class TestServer < Minitest::Test
  def setup
    @path = '/Users/Otto/Programming/Minecraft/how-minecraft/minecraft_server.jar'
  end

  def test_start
    s = MinecraftBridge::Server.new(@path)
    s.start
    sleep 10
    s.stop
    # sleep 10
  end
end
