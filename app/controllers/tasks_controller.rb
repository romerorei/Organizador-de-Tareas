class TasksController < ApplicationController
  load_and_authorize_resource # metodo de devise: con esto decime que todo lo que esta dentro de ability y la tarea (task) se va a asumir como reglas de acceso a este controlador
  # load_and_authorize_resource reconoce al ability por convencion
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index

    # estas lineas me permiten q solo solo se muestren las tareas a las que el user sea owner o particpants
    # antes estaba @tasks = Task.All pero asi los usuaarios podian todas las tareas incluyendo las q no eran ni owner ni particpans
    @tasks = Task.joins(:participants).where(
      'owner_id = ? OR participants.user_id = ?',
      current_user.id,
      current_user.id,
    ).group(:id)
  
  
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.owner = current_user 
    # @tasks.owner hace referencia al belongs_to :owner, class_name: 'User' que esta en el modelos taks.rb
    # @task.owner = current_user esta en la action create pero antes de if @task.save (abajito)
    # al estar antes permiete que el usuario actual que se guarda en el metodo de rails current_user pueda crear una tarea
    # si esta despues de  if @task.save el formulario de cracion de tarea da error pero no muestra el error y este error viene de la relacion owner
    # la rfelacio owner solo permita el propietario de la tarea la modifique
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(
          :name,
          :description,
          :due_date,
          :category_id,
          # con participating_user le decimos al action q no solo va a recibir informaion desde la tares 
          # si no que tambien recibira informacion anidada de la asosiacion el participating_user
          # se le agrega attributes para q rails sepa que le enviamos parametros pero su nobre es participating_users
          participating_users_attributes: [
            :user_id,
            :role,
            :id,
            :_destroy
          ]
        )
    end
end

