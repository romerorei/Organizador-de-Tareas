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
class Task < ApplicationRecord
  # rails g scaffold Task name:string description:text due_date:date category:references
  belongs_to :category # pertence a una categoria esto es producto de category:references
  belongs_to :owner, class_name: 'User' # owner solo es el nombre de la relacion no de la tabla
  # con este belongs_to :owner añadimos la relacion entre propietario y la tarea
  # como rails no puede encontrar el modelo owner xq no existe le añadimos un parametro para sepa cual debe buscar
  # el que debe buscar es User

  has_many :participating_users, class_name: 'Participant'
  has_many :participants, through: :participating_users, source: :user
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
    # se iteran todos los usuarios q partiparan en la tarea y se le envia un corre
    # ParticipantMailer tiene una action q se llama new_task_email y deliver! un metodo nativo
    # se invoca la clase ParticipantMailer se la pasan con el metodo with los parametro task y user y se llama al action new_task_email
    # deliver! es para asegurar que el correo se envie
    def send_email
      (participants + [owner]).each do |user|
        ParticipantMailer.with(user: user, task: self).new_task_email.deliver!
      end
    end


end


