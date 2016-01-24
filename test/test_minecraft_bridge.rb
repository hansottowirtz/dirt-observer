require 'minitest/autorun'
require 'minecraft_bridge'

class TestMinecraftBridge < Minitest::Test
  def setup
  end

  def test_root
    assert_equal MinecraftBridge.root, File.expand_path('../..', __FILE__)
  end
end
