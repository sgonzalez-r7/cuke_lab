module CukeLab
RSpec.describe Analysis do
  describe '.run' do
    it 'creates a failure data csv file' do
          fixture = File.expand_path File.join('../../../support/fixtures/analysis_testing'), __FILE__
         data_dir = File.join(fixture, 'data')
      results_dir = Dir.mktmpdir
         csv_file = File.join(results_dir, 'failure_data.csv')
      csv_fixture = File.join(fixture, 'results', 'failure_data.csv')

      Analysis.configure(
          labs_root: 'labs_root',
            lab_dir: 'lab_dir',
           data_dir: data_dir,
        results_dir: results_dir,
             logger: ProgLogger.new(prog: 'test', io: '/dev/null'),
               name: 'red_board'
      )
      Analysis.run

      expect(FileUtils.identical?(csv_file, csv_fixture)).to eql true

      FileUtils.rm_rf results_dir
    end
  end
end
end
