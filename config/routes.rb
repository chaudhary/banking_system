Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'banking#index'

  get 'banking/enquiry' => 'banking#enquiry'
  get 'banking/deposit' => 'banking#deposit'
  get 'banking/withdraw' => 'banking#withdraw'

  get 'banking/download' => 'banking#download_txns_history'

end
