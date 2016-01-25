require 'minecraft_bridge/version'
require 'minecraft_bridge/util'
require 'minecraft_bridge/server'
require 'minecraft_bridge/server_types/vanilla_server'
require 'minecraft_bridge/server_types/spigot_server'
require 'zip'
require 'pty'
require 'colorize'
require 'waitutil'
require 'active_support/all'

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
    return @@all_servers.find_index server
  end
end

class Module
  def parent
    parent = self.to_s.split('::').reverse.drop(1).reverse.join('::').constantize
    puts "parent: #{parent}"
    return parent
  end
end
