# rails g migration addCodeToTask code:string
# aqui se le agrega una columnca a la tabla Task llamada code y de tipo string
class AddCodeToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :code, :string
  end
end
