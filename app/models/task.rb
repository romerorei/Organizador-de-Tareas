# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  due_date    :date
#  category_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :bigint           not null
#  code        :string
#
class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM # gema de maquinas de estados
  # rails g scaffold Task name:string description:text due_date:date category:references
  
  field :name, type: String
  field :description, type: String
  field :due_date, type: Date
  field :code, type: String
  field :status, type: String
  field :transitions, type: Array, default: []


  belongs_to :category # pertence a una categoria esto es producto de category:references
  belongs_to :owner, class_name: 'User' # owner solo es el nombre de la relacion no de la tabla
  # con este belongs_to :owner añadimos la relacion entre propietario y la tarea
  # como rails no puede encontrar el modelo owner xq no existe le añadimos un parametro para sepa cual debe buscar
  # el que debe buscar es User

  has_many :participating_users, class_name: 'Participant'
  # has_many :participants, through: :participating_users, source: :user
  # una tarea tiene muchos particiapntes (se hizo asi para que sea mas entendible)
  # el source es parecido al class_name y solo se coloca el modelo a relacionar
  # no utilizamos el has_many :user para que sea mas entendible con participants
    
  #
  has_many :notes


    # esta validacio es para que una tarea siempre tenga participantes
    # y este caso no validamos atributos si no la relacion participating_user
    validates :participating_users, presence: true

    #validacion presencia
    validates :name, :description, :category, presence: true 
    # esto le dice al sistema que name y description y category deben tener algo para poder guardarlas
    # si no dara error... presence es el tipo de validacion

    #Validacion de unicidad, para que se repita el noombre de la taera
    validates :name, uniqueness: { case_sensitive: false}
    # con uniqueness: { case_insensitive: false} no se permite que se repita el nombre de la tarea y es sensible a las mayusculas y minusculas

    # para las fechas due_date creamos una validacion personalisada
    # se utiliza el metodo validate es singular OJO!!!
    # sguido de un un metodos que nostros haremos
    validate :due_date_validity # metodo: due_date_validity es echo por nostros no es de rails

   before_create :create_code

   # esto activara el metodo send_email cuandon se haya creado la tarea
   after_create :send_email


    accepts_nested_attributes_for :participating_users, allow_destroy: true
  # este metodo nos permite validar internatemnte informacion anidada
  # podremos especificarque q relaciones van a recibir internamente informacio de otro formulario
  # alloq_destroy nos permite anidar informacion de los participantes si no tambien destruirla

  #esto es la gema de maquinas de estado
  #esto tendra 3 estado de t pendiente, terminada y en proceso
  aasm column: :status do #aqui le decimos q todos los procesos se van a guarda en la columna status
    state :pending, initial: true # el estado pending(pendiente es el incial)
    state :in_process, :finished
    
    after_all_transitions :audit_status_change # cuando se pasa de  una transcion a otro se llama este metodo audit_status

    event :start do
      transitions from: :pending, to: :in_process
    end

    event :finish do
      transitions from: :in_process, to: :finished
    end
  end

  def audit_status_change # este metodo cada vez q se haga una transicion de estado arro
    # el metodo 'set' sirva para actualizar la base de datos del modelo en este caso con transitions como campo
    # y push sirve para agregar esos valores
    set transitions: transitions.push(
      {
        from_state: aasm.from_state,
        to_state: aasm.to_state,
        current_event: aasm.current_event,
        timestamp: Time.zone.now
      }
    )
  end


  # has_many :participants, through: :participating_users, source: :user
  # el metodo particpants sustituyte a la linea de arriba ya que through no sirve en mongo 
  def participants #igger loudin
    participating_users.includes(:user).map(&:user)
  end


  def due_date_validity
    return if due_date.blank? #retornar si la fecha esta en blanco
    return if due_date > Date.today # si el due_date o fecha es mayor al dia de hoy es correcto si no retornar
    errors.add :due_date, I18n.t('task.errors.invalid_due_date')
    # con el metodo "erros" de añaden errores al modelo y se pasan a la vista
    # si no se cumplen las condicones el due_date tiene un proble
    # I18n.t('task.error.invalid_due_date') <--- este seria el mensaje q se mostrar en la intefaz grafica
    # ese mensaje nosotros lo creamos en el diccionario de es.yml ahi esta
  end


  def create_code
    self.code = "#{owner_id}#{Time.now.to_i.to_s(36)}#{SecureRandom.hex(8)}"
  end


    # aqui se invoca ParticipantMailer que viene de participant_maileer.rb
    # se iteran todos los usuarios q partiparan en la tarea y se le envia un correo
    # ParticipantMailer tiene una action q se llama new_task_email y deliver! un metodo nativo
    # se invoca la clase ParticipantMailer se la pasan con el metodo with los parametro task y user y se llama al action new_task_email
    # deliver! es para asegurar que el correo se envie
  def send_email
    # return # esto para q no envie tantos correos de los datos semilla cuando migramos el modelo task a mongo 
    return unless Rails.env.development?
    #Tasks::SendEmail.new.call self con el active job se elimina esta linea por la de abajo
     Tasks::SendEmailJob.perform_async id.to_s # el id es el id de la instacia del modelo task q estamos tratando
      # perform_async es un metodo del sucker_punch sirve para solucionar un problema boqueante cuando la el codigo se demora mucho es ejecutarse
      #Con perform_async ese proceso de hara de forma asincrona  y no bloqueante puede tomar mucho tiempo pero no impactara el flujo de creacionn de la tarea
      # ya que el job se quedara en paralalo procesando las tareas internamente (en este caso el envio de correos)
      # ya no se llama a traves del servicio si no a traves del job
      # Tasks::SendEmailJob.perform_in 5, id.to_s con esto, el envio se ejecuta 5 segundos despues de haber creado el correo


    #ESTAS LINEAS LAS MIGRAMOS A UN SERVICIO SEND_EMAIL.rb 
     #Tasks::SendEmail.new.call self de arriba es el llamado a ese servicio
      # (participants + [owner]).each do |user|
      #   ParticipantMailer.with(user: user, task: self).new_task_email.deliver!
      # end 
  end

end


