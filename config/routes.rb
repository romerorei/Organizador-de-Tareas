Rails.application.routes.draw do
  devise_for :users
  #devise_for :users # este metodo se genero con rails g devise User
  # deviser_for habilita las rutas necesaria para consumir el recurso de usuarios User
  resources :tasks do
    patch :trigger, on: :member #nueva ruta para editar el registro de una tarea para los eventos
    #las notas estan dentro del contexto de las tareas por lo q vamos a incidir en esos recurso
    # accederemos a una nota interta
    # solo se va a usar un metodo q es create
    # es el no,bre del controlador
    resources :notes, only: [:create], controller: 'tasks/notes'
  end
  resources :categories

  root 'tasks#index' # con root establecemos el indice de tareas como pagina principal
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
