require 'toft/command_executor'

module Toft
  class FileChecker
    
    include Toft::CommandExecutor
    
    def initialize(rootfs, path)
      @rootfs = rootfs
      @path = path
    end
        
    def exist?
      test("-e")
    end
    
    def directory?
      filetype == "directory"
    end
    
    def filetype
      stat("%F")
    end
    
    def owner
      stat("%U")
    end

    def group
      stat("%G")
    end
    
    def mode
      stat("%a")
    end
    
    private 
    def stat(format)
      cmd("chroot #{@rootfs} stat -c #{format} #{@path}").rstrip      
    end
    
    def test(op)
      cmd!("chroot #{@rootfs} test #{op} #{@path}")
      $? == 0 ? true : false
    end
  end
end