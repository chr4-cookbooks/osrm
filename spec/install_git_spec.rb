require 'chefspec'

describe 'osrm::install_git' do

  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new do |node|
      node.set['cpu']['total'] = 2
      node.set['memory']['total'] = 4096 * 1024
    end
    runner.converge 'osrm::install_git'
  end

  it 'should install required development packages' do
    packages = %w{
      git-core build-essential cmake
      libboost-all-dev libbz2-dev zlib1g-dev libluajit-5.1-dev libluabind-dev
      libxml2-dev libstxxl-dev libosmpbf-dev libprotoc-dev
    }

    packages.each do |pkg|
      expect(chef_run).to install_package pkg
    end
  end

  it 'should create target directory' do
    notifying_resource = chef_run.git('/opt/osrm')
    expect(notifying_resource).to notify 'directory[/opt/osrm/build]', :create
  end

  it 'should run cmake' do
    notifying_resource = chef_run.git('/opt/osrm')
    expect(notifying_resource).to notify 'execute[cmake ..]', :run
  end

  it 'should run make' do
    notifying_resource = chef_run.git('/opt/osrm')
    expect(notifying_resource).to notify 'execute[make]', :run
  end

  it 'should create symlinks' do
    %w{osrm-extract osrm-prepare osrm-routed}.each do |binary|
      expect(chef_run.link("/usr/local/bin/#{binary}")).to link_to "/opt/osrm/build/#{binary}"
    end
  end
end
