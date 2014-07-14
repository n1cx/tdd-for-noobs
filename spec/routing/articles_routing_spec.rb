require 'spec_helper'

describe 'routes for articles' do
  it 'should route get index' do
    expect(get: '/articles').to be_routable
    expect(get: '/articles').to route_to(controller: 'articles', action: 'index')
  end
end