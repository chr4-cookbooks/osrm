require 'chefspec'

describe 'osrm_test::map_routed_delete' do

  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new(step_into: [ 'osrm_routed' ]) do |node|
      node.set['cpu']['total'] = 2
      node.set['memory']['total'] = 4096 * 1024
    end
    runner.converge 'osrm_test::map_routed_delete'
  end

  it 'should stop osrm-routed service' do
    expect(chef_run).to stop_service 'osrm-routed-europe-car'
  end

  it 'should remove init.d upstart link' do
    expect(chef_run).to delete_file '/etc/init.d/osrm-routed-europe-car'
  end

  it 'should remove upstart script' do
    expect(chef_run).to delete_file '/etc/init/osrm-routed-europe-car.conf'
  end

  it 'should remove config file' do
    expect(chef_run).to delete_file '/etc/osrm-routed/europe-car.conf'
  end

  it 'should remove config directory (if empty)' do
    expect(chef_run).to delete_directory '/etc/osrm-routed'
  end
end
