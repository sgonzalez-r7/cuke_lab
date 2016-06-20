module CukeLab
RSpec.describe Experiment do
  before(:example) do
    Experiment.configure(
       features: ['se.feature'],
  features_root: 'features_root',
           name: 'se',
      cuke_opts: '--tags @focus',
              n: 3,
        dry_run: false,
        run_dir: 'run_dir',
       labs_root: 'labs_root',
         logger: ProgLogger.new(prog: 'test', io: '/dev/null')
    )
    allow(Kernel).to receive(:system).exactly(3).times
  end

  describe '.run_experiment with 3 iterations' do
    context '1st iteration' do
      it 'shells out cuke command for i=1' do
        cmd = <<_EOS_
#!/usr/bin/env bash
cd run_dir
cucumber --tags @focus --format json -o labs_root/se/data/run_00001.json features_root/se.feature
_EOS_
        expect(Kernel).to receive(:system).with(cmd)
      end
    end

    context '2nd iteration' do
      it 'shells out cuke command for i=2' do
        cmd = <<_EOS_
#!/usr/bin/env bash
cd run_dir
cucumber --tags @focus --format json -o labs_root/se/data/run_00002.json features_root/se.feature
_EOS_
        expect(Kernel).to receive(:system).with(cmd)
      end
    end

    context '3rd iteration' do
      it 'shells out cuke command for i=3' do
        cmd = <<_EOS_
#!/usr/bin/env bash
cd run_dir
cucumber --tags @focus --format json -o labs_root/se/data/run_00003.json features_root/se.feature
_EOS_
        expect(Kernel).to receive(:system).with(cmd)
      end
    end
  end
  after(:example) do
    Experiment.run
  end

end
end
