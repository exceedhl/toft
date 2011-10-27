module Toft
  module CommandExecutor
    def cmd!(cmd)
      system "sudo #{cmd}"
    end
    
    def cmd(cmd)
      `sudo #{cmd}`
    end 
  end
end