require 'rails_helper'

RSpec.describe '/articles routes' do
  it 'routes to article#index' do
    aggregate_failures do
      expect(get '/articles').to route_to(controller: 'articles', action: 'index') #equivalent to articles#index
      expect(get '/articles?page[number]=3').to route_to('articles#index', page: { "number" => "3" })
    end
  end

  it 'routes to article#show' do
    aggregate_failures do
    expect(get '/articles/1').to route_to(controller: 'articles', action: 'show', id:'1' )
    end
  end

end
