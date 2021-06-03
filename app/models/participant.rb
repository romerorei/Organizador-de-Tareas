
#rails g model Participant role:integer user:references task:references
#el modelo particpan esta en el medio del usuario y la tarea por eso tiene dos references
# relacion dirfecta con user y relaion directa con task
class Participant 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  #enum role: { responsible: 1, follower: 2 }
  
  ROLES = {
    responsible: 1,
     follower: 2
  }

  field :role, type: Integer

  belongs_to :user
  belongs_to :task

  def self.roles 
  # este metodo expone al publico la definicion de nuestras constasnte q internamente hemos definidos
    ROLES
    
  end



end
