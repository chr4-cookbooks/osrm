require 'chefspec'

describe 'osrm_test::map_prepare_if_missing' do

  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new(step_into: [ 'osrm_map_prepare' ]) do |node|
      node.set['cpu']['total'] = 2
    end
    runner.converge 'osrm_test::map_prepare_if_missing'
  end

  it 'should create contractor.ini' do
    expect(chef_run).to create_file_with_content '/opt/osrm/build/contractor.ini', "Threads = 2\n"
  end

  # it 'should not delete already prepared files' do
  # end

  it 'should run osrm-prepare with the correct arguments' do
    expect(chef_run).to execute_command('/opt/osrm/build/osrm-prepare /opt/osrm-data/europe/car/europe-latest.osrm /opt/osrm-data/europe/car/europe-latest.osrm.restrictions /opt/osrm/profiles/car.lua').with(
      timeout: 3600 * 24,
      cwd:     '/opt/osrm/build',
    )
  end
end

