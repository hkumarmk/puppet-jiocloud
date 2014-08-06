require 'spec_helper'
describe 'jiocloud' do

  context 'with defaults for all parameters' do
    it { should contain_class('jiocloud') }
  end
end
