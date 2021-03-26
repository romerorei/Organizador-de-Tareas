# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
#Este modelo se genero con:
#rails g devise User
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :owned_tasks # un usarios puede tener muchas tareas
  # owned_tasks son tareas propias creada el usuario
  has_many :partipations, class_name: 'Participant' #partipations se sale de la convecion por eso el class_name
  has_many :tasks, through: :participantions # esta relacion me permita al user acceder a las taeras pero solo en las que partiicipa
end
