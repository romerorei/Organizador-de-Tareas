#rails g rspec:request task
require 'rails_helper'
# esto es para pruebas de peticion GET, POST y mas

RSpec.describe "Tasks", type: :request do

  # esto pes para crear un usuario de prueba y hacerlo q inicie sesion
  # before(:each) { sign_in user } antes de cada tarea se inicia sesion de prueba
  let(:user) {create :user}
  before(:each) { sign_in user }
  
  describe "GET /tasks" do
    it "works! (now write some real specs)" do
      get tasks_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /tasks/new" do
    it "Peticion de prueba para nueva tarea" do
      get new_task_path
      expect(response).to render_template(:new)
    end
  end

  describe "POST /tasks" do
    let(:category) { create :category }
    let(:participant) { create :user}
    let(:params) do
      {
        "task"=>{
          "name"=>"tarea 555",
          "due_date"=> Date.today + 5.days,
          "category_id"=>category.id.to_s,
          "description"=>"test",
          "participating_users_attributes"=>{
            "0"=>{
              "user_id"=>participant.id.to_s,
              "role"=>"1",
              "_destroy"=>"false"
            }
          }
        }
      }
  
    end

    it 'creara una nueva tarea y redirect a la pagina mostrar' do
      post '/tasks', params: params

      expect(response).to redirect_to(assigns(:task))
      follow_redirect!
      expect(response).to render_template(:show)
      expect(response.body).to include('Task was successfully created.')
    end
    
  
  end

  # cuando se llame a esta peticion nuestra tarea deberia estar actualizdada
  describe "PATCH /tasks/:id/trigger" do
    let(:participants_count) { 4 }
    let(:event) { 'start' }
    subject(:task) do
      build(:task_with_participants, owner: user, participants_count: participants_count)
    end

    it 'updates the state' do
      task.save # para q la tarea se guarde
      # el metodo lo patch lo proveee el dsl de rspec
      # se esta emulando una peticion de tipo patch
      # :trigger_task_path esto viene de las routes.rb
      patch trigger_task_path(task, event: event, format: :js)
      expect(task.reload.status).to eq 'in_process'
      #video 31 de rails intermedio
    end
  end
  

end
