module Toft
  module CommandExecutor
    def cmd!(cmd)
      system "#{sudo}#{cmd}"
    end
    
    def cmd(cmd)
      `#{sudo}#{cmd}`
    end 
    
    private
    def sudo
      ENV["USER"] == "root" ? "" : "sudo "
    end
  end
end