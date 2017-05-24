Rails.application.routes.draw do
  resources :searches do
  	collection do
  	 	get 'latest'
  	end
  end
  resources :articles do
  	collection do
  		get 'search'
  	end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
