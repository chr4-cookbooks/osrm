require 'chefspec'

describe 'osrm_test::map_download_if_missing' do

  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new(step_into: [ 'osrm_map_download' ]) do |node|
      node.set['cpu']['total'] = 2
      node.set['memory']['total'] = 4096 * 1024
    end
    runner.converge 'osrm_test::map_download_if_missing'
  end

  it 'create data directory for region' do
    expect(chef_run).to create_directory '/opt/osrm-data/europe'
  end

  it 'should download map data' do
    expect(chef_run).to create_remote_file_if_missing '/opt/osrm-data/europe/europe-latest.osm.pbf'
  end
end
