
class Category
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :name, type: String
    field :description, type: String

    #una categoria puede tener muchas tasks
    has_many :tasks # tiene muchas tareas o tasks

    #validacion presencia
    validates :name, :description, presence: true 
    # esto le dice al sistema que name y description deben tener algo para poder guardarlas
    # si no dara error... presence es el tipo de validacion

    #Validacion de unicidad, para que se repita el noombre de la categoria
    validates :name, uniqueness: { case_sensitive: false}
    # con uniqueness: { case_insensitive: false} no se permite que se repita el nombre de la tarea y es sensible a las mayusculas y minusculas
end
