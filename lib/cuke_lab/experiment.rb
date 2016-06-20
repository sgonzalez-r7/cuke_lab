module CukeLab
module Experiment
class  << self
  attr_reader :features,
              :features_root,
              :name,
              :cuke_opts,
              :n,
              :dry_run,
              :labs_root,
              :logger,
              :run_dir

  def configure(features:,
                features_root:,
                name:,
                cuke_opts:,
                n:,
                run_dir:,
                dry_run:,
                labs_root:,
                logger:)
         @features = features
    @features_root = features_root
             @name = name
        @cuke_opts = cuke_opts
                @n = n
          @dry_run = dry_run
          @run_dir = run_dir
        @labs_root = labs_root
           @logger = logger
  end

  def run
    logger.log :info, 'begin'
    logger.log :info, 'experiment: ' + name
    logger.log :info, 'n = ' + n.to_s
    logger.log :info, 'cuke_opts: '  + cuke_opts

    features.each do |feature|
      logger.log :info, 'run feature: ' + feature
    end

    run_experiment
    logger.log :info, 'end'
  end

private

  def data_dir
    File.join(lab_dir, 'data')
  end

  def cucumber_command(i)
    cmd_parts  = []
    cmd_parts += ['cucumber']
    cmd_parts += [cuke_opts]
    cmd_parts += ['--format', 'json']
    cmd_parts += ['-o', out_file(i)]

    features.each do |feature|
      cmd_parts += [File.join(features_root, feature)]
    end

    cmd = cmd_parts.join(' ')
  end

  def lab_dir
    File.join(labs_root, name)
  end

  def out_file(i)
    basename = 'run_' + sprintf("%05d", i + 1) + '.json'
    File.join(data_dir, basename)
  end

  def run_experiment
    n.times do |i|
      logger.log :info, 'iteration ' + (i+1).to_s
      logger.log :info, 'shell out: ' + "\n\n" + script(cucumber_command(i))
      Kernel.system script(cucumber_command(i)) unless dry_run
    end
  end

  def script(cmd)
    lines  = []
    lines += ['#!/usr/bin/env bash']
    lines += ['cd ' + run_dir]
    lines += [cmd]
    lines += ['']

    contents = lines.join("\n")
  end
end
end
end
