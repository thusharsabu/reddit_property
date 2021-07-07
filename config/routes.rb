Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # namespace '/properties' do
  #   scope controller: 'reddit' do
  #     get 'index' => :index
  #     # get 'show(/:name)' => :show
  #     # get 'search(/:name/:stack/:region)' => :search
  #   end
  # end
  namespace :properties do
    get 'index', action: :index, controller: 'reddit', defaults: { format: :json }
    get 'populate', action: :populate, controller: 'reddit', defaults: { format: :json }
    get 'show', action: :show, controller: 'reddit', defaults: { format: :json }
    post 'upvote', action: :upvote, controller: 'reddit', defaults: { format: :json }
    post 'downvote', action: :downvote, controller: 'reddit', defaults: { format: :json }
  end
end
