Rails.application.routes.draw do
  resources :sign_ups, only: [:new, :create]
  resources :sign_ins, only: [:new, :create, :destroy]

  resources :todos,    only: [:index, :new, :create, :edit, :update, :destroy]

  resource :all_completed_todos, only: [:destroy], as: :all_completed_todos, controller: 'todos/all_completed'

  scope "todos/:todo_id" do
    resource :completed, only: [:create], as: :completed_todos, controller: 'todos/completed'
  end

  root to: 'home#show'
end
