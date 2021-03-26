# rails g model Participant role:integer user:references task:references
#el modelo particpan esta en el medio del usuario y la tarea por eso tiene dos references
class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.integer :role
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
