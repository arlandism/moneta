Rails.application.routes.draw do
  namespace 'v1' do
    post 'log', controller: 'ip'
    post 'seen', controller: 'ip'
    get 'distinct', controller: 'ip'
  end
end
