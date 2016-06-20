require 'logger'

module CukeLab
class  ProgLogger < Logger
  def initialize(prog:, io: STDOUT)
    super(io)
    self.formatter = proc do |serverity, time, progname, msg|
      [
        '[' + serverity[0].downcase + ']',
        prog,
        time,
        msg,
        "\n"
      ].join(' ')
    end
  end

  def log(type, msg)
    case type
      when :error
        self.error msg
      when :fatal
        self.fatal msg
      when :info
        self.info  msg
      when :warn
        self.warn  msg
      else
        raise 'Invalid log type: ' + type
    end
  end
end
end
