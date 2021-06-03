# rails g rspec:system task
# pruebas de sistema
require 'rails_helper'

RSpec.describe "Tasks", type: :system do
    # esto pes para crear un usuario de prueba y hacerlo q inicie sesion
  # before(:each) { sign_in user } antes de cada tarea se inicia sesion de prueba
  let(:user) {create :user}
  before(:each) { sign_in user }

  # revisaremos que tenga el titulo correcto
  describe "GET/tasks" do
    it "Verificacion de titulo correcto" do
      visit '/tasks' # visit es un metodo de capybara q te lleva a esa ruta
      # expect con esto se veirifcia q q la pagina de la ruta contnga 'Lista de Tareas'
      expect(page).to have_content 'Lista de Tareas' 
    end
  end

  describe "POST /tasks" do
    let!(:category) { create :category }
    let!(:participant) { create :user }
    # el signo ! en let siginifica q no esperara a q sea invocado sino q creara la category apenas la prueba este corriendo
    
    it "Crea una nueva tarea", js: true do
      visit '/tasks/new' #visit es un metodo de capybara que te lleva a esa ruta
      fill_in 'task[name]', with: 'Prueba Capybara y Selenium como WebDriver'
      fill_in 'task[description]', with: 'Descripcion de prueba capybara'
      fill_in 'task[due_date]', with: Date.today + 5.days
      # la linea de abajo con selectize no sirve
      # select category.name, from: 'task[category_id]'
      page.execute_script(
        "document.getElementById('task_category_id').selectize.setValue('#{category.id}')"
      )

      click_link 'Agregar un participante'
      # este codigo con selectize no sirve
      # xpath = '//*[@id="new_task"]/div[1]/div[4]/div[1]'
      # within(:xpath, xpath) do
      #   select participant.email, from: 'Usuario'
      #   select 'responsible', from: 'Rol'
      # end
      page.execute_script(
        "document.querySelector('.selectize.responsible').selectize.setValue('#{participant.id}')"
      )

      page.execute_script(
        "document.querySelector('.selectize.role').selectize.setValue('1')"
      )

      click_button 'Crear Task'

      expect(page).to have_content('Task was successfully created.')
    end
  end

end
