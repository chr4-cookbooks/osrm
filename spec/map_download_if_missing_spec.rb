require 'chefspec'

describe 'osrm_test::map_download_if_missing' do

  let(:chef_run) do
    runner = ChefSpec::Runner.new(step_into: [ 'osrm_map_download' ]) do |node|
      node.set['cpu']['total'] = 2
    end
    runner.converge 'osrm_test::map_download_if_missing'
  end

  it 'should create data directory for region' do
    expect(chef_run).to create_directory '/opt/osrm-data/europe'
  end

  it 'should download map data' do
    expect(chef_run).to create_remote_file_if_missing '/opt/osrm-data/europe/europe-latest.osm.pbf'
  end
end
