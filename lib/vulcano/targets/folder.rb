# encoding: utf-8
require 'vulcano/targets/dir'
require 'vulcano/targets/file'

module Vulcano::Targets
  class FolderTarget
    def handles?(target)
      File::directory?(target)
    end

    def resolve(target)
      # find all files in the folder
      files = Dir[File.join(target,'**','*')]
      # remove the prefix
      files = files.map{|x| x[target.length+1..-1]}
      # get the dirs helper
      helper = DirsHelper.getHandler(files)
      if helper.nil?
        raise "Don't know how to handle folder #{target}"
      end
      # get all file contents
      file_handler = Vulcano::Targets.modules['file']
      test_files = helper.get_filenames(files)
      test_files.map do |f|
        file_handler.resolve(File.join(target,f))
      end
    end
  end

  Vulcano::Targets.add_module('folder', FolderTarget.new)
end
