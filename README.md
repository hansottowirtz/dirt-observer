# MinecraftBridge

Bridging the gap between Minecraft and Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minecraft-bridge', github: 'hansottowirtz/minecraft-bridge'
```

And then execute:

    $ bundle

## Usage

MinecraftBridge provides a way to monitor a Minecraft server. It has two ways: via the console or via the NBT files.
```ruby
server = MinecraftBridge::Server.new('/path/to/minecraft_server.jar')
server.start
server.stop
```
#### Console
MinecraftBridge creates a pseudoterminal in which it monitors the console.
It scans the messages for known patterns and highlights specialties.
#### NBT
Working with the NBT gem

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hansottowirtz/minecraft_bridge. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
