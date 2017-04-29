Rails.application.routes.draw do
  resources :users do
    #member do
      #get 'confirm_email'
    #end
    # (дополнительный маршрут, который распознает /users/id/confirm_email с GET и направит в экшн confirm_email контроллера UsersController)
    # более короткая запись
    get 'confirm_email', on: :member
  end
  resources :sessions, only: [:new, :create, :destroy]
  #сброс пароля
  resources :resets, only: [:new, :create, :edit, :update]
  #обновление email
  resources :update_emails, only: [:edit, :update]
  resources :albums
  resources :images

  root 'main#index'

  #сброс пароля
  get '/reset/:id/edit',  to: 'resets#update'

  #регистрация
  get '/signup',  to: 'users#new'
  #вход
  get '/signin',  to: 'sessions#new'
  #выход
  delete '/signout', to: 'sessions#destroy'

  #добавляем альбом
  get '/new_album',  to: 'albums#new'

  #загрузка фото
  post '/albums/:id',  to: 'images#add_image'

  #редактируем альбом
  post '/albums/:id/edit',  to: 'albums#update'

  #удаление альбома
  delete '/delalbum', to: 'albums#destroy'

end
