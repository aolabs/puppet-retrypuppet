require 'spec_helper'
describe 'retrypuppet' do
  context 'with default values for all parameters' do
    it { should contain_class('retrypuppet') }
  end
end
