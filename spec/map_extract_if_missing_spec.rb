require 'chefspec'

describe 'osrm_test::map_extract_if_missing' do

  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new(step_into: [ 'osrm_map_extract' ]) do |node|
      node.set['cpu']['total'] = 2
      node.set['memory']['total'] = 4096 * 1024
    end
    runner.converge 'osrm_test::map_extract_if_missing'
  end

  it 'should create extractor.ini' do
    expect(chef_run).to create_file_with_content '/opt/osrm/build/extractor.ini', "Memory = 3\nThreads = 2\n"
  end

  it 'should create .stxxl' do
    expect(chef_run).to create_file_with_content '/opt/osrm/build/.stxxl', "disk=/var/tmp/stxxl,1024,syscall\n"
  end

  it 'should link downloaded map to profile' do
    expect(chef_run.link('/opt/osrm-data/europe/car/europe-latest.osm.pbf')).to link_to '/opt/osrm-data/europe/europe-latest.osm.pbf'
  end

  # it 'should not delete already extracted files' do
  # end

  it 'should run osrm-extract with the correct arguments' do
    expect(chef_run).to execute_command('/opt/osrm/build/osrm-extract /opt/osrm-data/europe/car/europe-latest.osm.pbf /opt/osrm/profiles/car.lua').with(
      timeout: 3600 * 24,
      cwd:     '/opt/osrm/build',
    )
  end
end

