require 'chefspec'

describe 'osrm_test::map_routed_create' do

  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new(step_into: [ 'osrm_routed' ]) do |node|
      node.set['cpu']['total'] = 2
      node.set['memory']['total'] = 4096 * 1024
    end
    runner.converge 'osrm_test::map_routed_create'
  end

  it 'should create config directory' do
    expect(chef_run).to create_directory '/etc/osrm-routed'
  end

  it 'should create config file' do
    expect(chef_run).to create_file '/etc/osrm-routed/europe-car.conf'
  end

  it 'should create osrm user' do
    expect(chef_run).to create_user 'osrm-routed'
  end

  it 'should deploy upstart script' do
     expect(chef_run).to create_file '/etc/init/osrm-routed-europe-car.conf'
  end

  it 'should create init.d upstart link' do
    expect(chef_run.link('/etc/init.d/osrm-routed-europe-car')).to link_to '/lib/init/upstart-job'
  end

  it 'should start osrm-routed service' do
    expect(chef_run).to start_service 'osrm-routed-europe-car'
  end
end
