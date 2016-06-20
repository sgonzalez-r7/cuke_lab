require 'csv'

module CukeLab
module Analysis
class  << self
  attr_reader :lab_root,
              :lab_dir,
              :data_dir,
              :results_dir,
              :logger,
              :name,
              :distribution,
              :n_invalid

  def configure(labs_root:,
                lab_dir:,
                data_dir:,
                results_dir:,
                logger:,
                name:)
      @labs_root = lab_root
        @lab_dir = lab_dir
       @data_dir = data_dir
    @results_dir = results_dir
         @logger = logger
           @name = name
  end

  def run
    logger.log :info, 'begin'
    logger.log :info, 'analysis: ' + name
    logger.log :info, data_files.count.to_s + ' data files to process'

    logger.log :info, 'calculating failure distribution'

    generate_distribution

    logger.log :info,'failure distribution calculated.'
    logger.log :info, n_invalid.to_s + ' invalid json file(s)'

    write_json
    write_csv
  end

private

  def data_files
    Dir[File.join(data_dir, '*.json')]
  end

  def generate_distribution
    failed = []
    n_invalid = 0
    data_files.each do |f|
      begin
        logger.log :info, 'processing ' + File.join(name, 'data', File.basename(f))
        features = load_json(f)

        features.each do |feature|
          feature_file = feature['uri']

          feature['elements'].each do |e|
            failures = e['steps'].select { |s| s['result']['status'] == 'failed' }

            failures.each do |failure|
              failed_step = {
                      'feature' => feature_file,
                     'scenario' => e['keyword'] + ': ' + e['name'],
                         'step' => failure['keyword']  + failure['name'],
                'error_message' => failure['result']['error_message'].split(/\n/)[0]
              }
              failed += [failed_step]
            end
          end
        end
      rescue
        logger.log :error, 'invalid json: ' + File.join(name, 'data', File.basename(f)) + '. ignoring'
        n_invalid += 1
      end
    end

    dist = {}
    failed.each do |f|
      dist[f] = 0 unless dist[f]
      dist[f] += 1
    end

    list = []
    dist.each_pair do |k,v|
      list << {failure: k, n: v}
    end

    @distribution = list.sort { |a,b| b[:n] <=> a[:n]  }
    @n_invalid    = n_invalid
  end

  def load_json(file)
    JSON.parse( File.read(file) )
  end

  def write_csv
    file = File.join(results_dir, 'distribution.csv')
    i = 0
    CSV.open(file, 'w') do |csv|
      distribution.each do |p|
              feature = p[:failure]['feature']
             scenario = p[:failure]['scenario']
                 step = p[:failure]['step']
        error_message = p[:failure]['error_message']
                    n = p[:n]

        csv << [feature, scenario, step, error_message, i+=1, n]
      end
    end
    logger.log :info, 'csv written ' + File.join(name, 'results', File.basename(file))
  end

  def write_json
    file = File.join(results_dir, 'distribution.json')
    File.open(file, 'w') do |f|
      f.write JSON.pretty_generate(distribution)
    end

    logger.log :info, 'json written ' + File.join(name, 'results', File.basename(file))
  end
end
end
end
