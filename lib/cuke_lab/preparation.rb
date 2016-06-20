module CukeLab
module Preparation
class << self
  attr_reader :labs_root
  attr_reader :logger
  attr_reader :name

  def configure(name:,labs_root:,logger:)
        @name = name
    @labs_root = labs_root
      @logger = logger

    self
  end

  def run
    logger.log :info, 'begin'
    build_structure
    logger.log :info, 'complete'
  end

private

  def build_structure
    unless Dir.exist? File.join(labs_root, name)
      [ File.join(name),
        File.join(name, 'data'),
        File.join(name, 'results')
      ].each do |dir|
        FileUtils.mkdir File.join(labs_root, dir)
        logger.log :info, 'created dir ' + File.join(File.basename(labs_root), dir)
      end
    else
      logger.log :fatal, 'directory structure NOT created. ' + name + ' already exists.'
      logger.log :fatal, 'FATAL. exiting!'
      exit 1
    end
  end
end
end
end
