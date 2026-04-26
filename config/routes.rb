Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get    'sign-up'                    => 'sessions#sign_up',                    as: :sign_up
  post   'session/create_account'     => 'sessions#create_user',                as: :create_user

  get    'dashboard'                  => 'dashboard/base#index',                as: :dashboard_index
  get    'dashboard/mailer'           => 'dashboard/mailer#index',              as: :dashbord_mailer
  get    'dashboard/profile'          => 'dashboard/profile#index',             as: :dashboard_profile
  delete 'dashboard/profile'          => 'dashboard/profile#destroy'
  put    'dashboard/profile/password' => 'dashboard/profile#update_password',   as: :update_password
  put    'dashboard/profile/email'    => 'dashboard/profile#update_email',      as: :update_email
  get    'dashboard/profile/verify'   => 'dashboard/profile#send_verification', as: :send_verification
  get    'dashboard/pages'            => 'dashboard/pages#index',               as: :dashboard_page

  get    'suspicious-report/:code'    => 'dashboard/profile#suspicious_report'
  get    'suspend/:code'              => 'dashboard/profile#suspend',           as: :suspend_user
  get    'email-verify/:code'         => 'dashboard/profile#email_verification'
  put    'confirmation/:code'         => 'mailing_list#confirmation',           as: :confirmation_mailing_list
  get    'confirm/:code'              => 'mailing_list#confirm',                as: :confirm_mailing_list
  get    'unsubscribe/:code'          => 'mailing_list#unsubscribe',            as: :unsubscribe_mailing_list

  post   '/'                          => 'site#email_signup',                   as: :email_signup

  # Defines the root path route ("/")
  root "site#index"
end
