require 'minecraft_bridge/version'
require 'minecraft_bridge/util'
require 'minecraft_bridge/server'
require 'minecraft_bridge/console'
require 'zip'
require 'pty'
require 'colorize'
require 'waitutil'

module MinecraftBridge
  Thread.abort_on_exception = true
  # Your code goes here...
  def self.root
    File.expand_path('../..', __FILE__)
  end

  @@all_servers = []

  def self.all_servers
    @@all_servers
  end

  def self.add_server(server)
    @@all_servers << server
  end
end
