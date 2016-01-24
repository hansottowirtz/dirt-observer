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

    def self.valid_minecraft_jar?(file)
      zip = Zip::File.new(file)
      contents = zip.read('META-INF/MANIFEST.MF')
      if contents.include? 'net.minecraft.server'
        true
      else
        return 'Valid jar, no valid manifest'
      end
    rescue StandardError => e
      return "Couldn't open jar: #{e}"
    ensure
      zip.close if zip
    end

    def self.pid_alive?(pid)
      return PTY.check(pid).nil? # true if alive
    end

  end
end
