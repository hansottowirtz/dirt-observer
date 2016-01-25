require 'minitest/autorun'
require 'minecraft_bridge'

class TestServer < Minitest::Test
  def setup
    @path = '/Users/Otto/Programming/Minecraft/how-minecraft/minecraft_server.jar'
    @path2 = '/Users/Otto/Programming/Minecraft/how-minecraft2/minecraft_server.jar'
    s = MinecraftBridge::Server.make(@path)
    s2 = MinecraftBridge::Server.make(@path2)
  end

  # def test_start
  #   s = MinecraftBridge::Server.make(@path)
  #   s.start
  #   sleep 10
  #   s.stop
  # end

  def test_multiple_servers
    s = MinecraftBridge::Server.make(@path)
    s2 = MinecraftBridge::Server.make(@path2)
    s.start
    sleep 10
    s.stop
    s2.start
    sleep 10
    s2.stop
  end
end
