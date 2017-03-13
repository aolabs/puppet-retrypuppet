require 'spec_helper'

describe 'retrypuppet' do

  it { should contain_class('retrypuppet') }

  it { is_expected.to contain_package('coreutils').with(ensure: 'present') }
  it { is_expected.to contain_package('python').with(ensure: 'present') }

  it { is_expected.to contain_file('/usr/local/bin/retrypuppet')
    .with(
      :ensure => 'present',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0555',
    )
  }

end
