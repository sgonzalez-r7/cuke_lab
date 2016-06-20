module CukeLab
RSpec.describe Preparation do
  context 'when lab directory already exists' do
    it 'does not disturb the existing directory' do
      tmp_dir    = Dir.mktmpdir
      time_stamp = File.mtime tmp_dir

      Preparation.configure(
            name: 'se',
       labs_root: tmp_dir,
          logger: ProgLogger.new(prog: 'test', io: '/dev/null')
      )

      Preparation.run

      expect(File.mtime(tmp_dir)).to eql time_stamp

      FileUtils.rm_rf tmp_dir
    end
  end
end
end
