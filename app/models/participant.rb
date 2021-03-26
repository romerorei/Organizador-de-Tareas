# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  role       :integer
#  user_id    :bigint           not null
#  task_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#rails g model Participant role:integer user:references task:references
#el modelo particpan esta en el medio del usuario y la tarea por eso tiene dos references
# relacion dirfecta con user y relaion directa con task
class Participant < ApplicationRecord
  enum role: { responsible: 1, follower: 2 }
  
  belongs_to :user
  belongs_to :task
end
