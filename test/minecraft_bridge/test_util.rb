require 'minitest/autorun'
require 'minecraft_bridge'

class TestUtil < Minitest::Test
  def setup
    @path = '/Users/Otto/Programming/Minecraft/how-minecraft/minecraft_server.jar'
  end

  def test_valid_minecraft_jar?
    assert MinecraftBridge::Util.valid_minecraft_jar?(@path)
  end
end
