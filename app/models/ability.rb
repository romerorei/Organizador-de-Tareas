# https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
# frozen_string_literal: true
# asi se genero: rails g cancan:ability
# en este archivo es donde vamos a establecer las reglas de acceso y permiso q permitiran saber 
# si una persona es apta para acceder a una funcionalidad o no 

class Ability
  include CanCan::Ability

  def initialize(user) # asumimos q este user ya esta loggeado y es nuestro current_user
    #El can método se utiliza para definir permisos y requiere dos argumentos. La primera es la acción para la que está configurando el permiso, la segunda es la clase de objeto en la que lo está configurando.
   #con la palabra manage el user tiene accceso a todo si le agfregamos task lo limitamos a todo pero dentro de las tareas
    can :manage, Task, owner_id: user.id
    #'owner_id: user.id': con esto solo el usuario que sea owner de la tarea puede modificarla
 
    # esto es para los user pasticpan puedan administra las tarea de las q no son owner pero si particpants
    can :read, Task, participating_users: { user_id: user.id }

  end

end
