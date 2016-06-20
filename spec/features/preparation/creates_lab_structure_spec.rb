module CukeLab
RSpec.describe Preparation do
  describe '.run' do
    before(:context) do
      tmp_dir = Dir.mktmpdir
      Preparation.configure(
            name: 'se',
       labs_root: tmp_dir,
          logger: ProgLogger.new(prog: 'test', io: '/dev/null')
      )
      Preparation.run
    end

    context 'a successful preparation' do
      let(:labs_root) { Preparation.labs_root }
      let(:name)      { Preparation.name }

      it 'creates the lab directory' do
        lab_dir = File.join(labs_root, name)

        expect(Dir.exist?(lab_dir)).to eql true
      end

      it 'creates the data directory' do
        data_dir = File.join(labs_root, name, 'data')

        expect(Dir.exist?(data_dir)).to eql true
      end

      it 'creates the results directory' do
        results_dir = File.join(labs_root, name, 'results')

        expect(Dir.exist?(results_dir)).to eql true
      end
    end

    after(:context) do
      FileUtils.rm_rf File.join(Preparation.labs_root, Preparation.name)
    end
  end
end
end
