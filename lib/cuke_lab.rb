require 'json'
require 'fileutils'
require 'tempfile'
require 'yaml'
require 'cuke_lab/analysis'
require 'cuke_lab/experiment'
require 'cuke_lab/prog_logger'
require 'cuke_lab/preparation'

module  CukeLab
class << self
  def config
    {
      'run_dir'       => File.expand_path('../../../..', __FILE__),
      'features_root' => File.expand_path('../../../../features', __FILE__)
    }
  end

  def features_root
    CukeLab.config['features_root']
  end

  def labs_root
    File.join(CukeLab.root, 'labs')
  end

  def root
    File.expand_path('../..', __FILE__)
  end

  def run_dir
    CukeLab.config['run_dir']
  end

  def run_analysis(name:)
        lab_dir = File.join(labs_root, name)
       data_dir = File.join(lab_dir, 'data')
    results_dir = File.join(lab_dir, 'results')

    Analysis.configure(
        labs_root: labs_root,
          lab_dir: lab_dir,
         data_dir: data_dir,
      results_dir: results_dir,
           logger: ProgLogger.new(prog: 'analysis'),
             name: name
    )

    Analysis.run
  end

  def run_experiment(features:, name:, cuke_opts:, n:, dry_run:)
    Experiment.configure(
       features: features,
  features_root: CukeLab.features_root,
           name: name,
      cuke_opts: cuke_opts,
              n: n,
        dry_run: dry_run,
        run_dir: CukeLab.run_dir,
      labs_root: labs_root,
         logger: ProgLogger.new(prog: 'repeat')
    )

    Experiment.run
  end

  def run_preparation(name:)
    Preparation.configure(
          name: name,
     labs_root: labs_root,
        logger: ProgLogger.new(prog: 'prepare')
    )

    Preparation.run
  end
end
end
