module CukeLab
RSpec.describe Analysis do
  describe '.run' do
    it 'creates a failure dist json file' do
          fixture = File.expand_path File.join('../../../support/fixtures/analysis_testing'), __FILE__
         data_dir = File.join(fixture, 'data')
      results_dir = Dir.mktmpdir
        json_file = File.join(results_dir, 'distribution.json')
     json_fixture = File.join(fixture, 'results', 'distribution.json')

      Analysis.configure(
          labs_root: 'labs_root',
            lab_dir: 'lab_dir',
           data_dir: data_dir,
        results_dir: results_dir,
             logger: ProgLogger.new(prog: 'test', io: '/dev/null'),
               name: 'red_board'
      )
      Analysis.run

      expect(FileUtils.identical?(json_file, json_fixture)).to eql true

      FileUtils.rm_rf results_dir
    end
  end
end
end
