# esta clase se genero con rails g migration AddOwnerToTask user:references
class AddOwnerToTask < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :owner, null: false, foreign_key: { to_table: :users}, index: true
    # esto es para añadir un relacion entre tareas y usuarios
    # a pesar de que la relacion se llama owner con foreign_key:{to_table: :users} le decimos que debe buscar en la tabla users
    # le damos un index a la relacio para que sea mas rapida su desempeño
  end
end

