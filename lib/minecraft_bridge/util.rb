module MinecraftBridge
  class Util
    def self.valid_zip?(file)
      zip = Zip::File.open(file)
      true
    rescue StandardError
      false
    ensure
      zip.close if zip
    end

    def self.get_server_type(file)
      zip = Zip::File.new(file)
      contents = zip.read('META-INF/MANIFEST.MF')
      if contents.include? 'net.minecraft.server'
        return true, MinecraftBridge::VanillaServer
      elsif contents.include? 'org.bukkit.craftbukkit.Main'
        return true, MinecraftBridge::SpigotServer
      else
        return false, 'Valid jar, no valid manifest'
      end
    rescue StandardError => e
      return false, "Couldn't open jar: #{e}"
    ensure
      zip.close if zip
    end

    def self.pid_alive?(pid)
      return PTY.check(pid).nil? # true if alive
    end

    def self.select_regex(text, regexes)
      regexes.each do |regex|
        if text =~ regex
          return regex
        end
      end
      return nil
    end
  end
end
