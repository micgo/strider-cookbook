require 'chefspec'
require 'spec_helper'

describe 'strider-cd::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }  

  before do
    stub_command("/usr/local/bin/npm -v 2>&1 | grep '1.3.5'").and_return(false)
    stub_command("mongo strider-foss --eval 'printjson(db.users.count())' --quiet | grep 0").and_return(true)
  end

  it 'includes the nodejs::npm recipe' do
    expect(chef_run).to include_recipe('nodejs::npm')
  end

  it 'includes the mongodb recipe' do
    expect(chef_run).to include_recipe('mongodb')
  end

  it 'checks syncs with the Strider-CD repository' do
    expect(chef_run).to sync_git('/opt/strider').with(repository: 'git://github.com/Strider-CD/strider.git')
  end

  it 'should execute npm install in the Strider directory' do
    expect(chef_run).to run_execute('npm install')
  end

  it 'should install the Forever NPM module' do
    expect(chef_run).to run_execute('npm install forever -g')
  end

  it 'should not add a Strider CD admin user if users exist' do
    stub_command("mongo strider-foss --eval 'printjson(db.users.count())' --quiet | grep 0").and_return(false)
    expect(chef_run).to_not run_execute('bin/strider addUser -l admin@stridercd.com -p password -a true')
  end

  it 'should add a Strider CD admin user if no users exist' do
    stub_command("mongo strider-foss --eval 'printjson(db.users.count())' --quiet | grep 0").and_return(true)
    expect(chef_run).to run_execute('bin/strider addUser -l admin@stridercd.com -p password -a true')
  end
end