require 'spec_helper'

describe 'Resources on Ubuntu 16.04' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: %w(gpg_install gpg_generate)) }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end
