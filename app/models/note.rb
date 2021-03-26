# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  body       :text
#  user_id    :bigint           not null
#  task_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rails g model Note body:text user:references task:references
class Note < ApplicationRecord
  belongs_to :user
  belongs_to :task

  # como solo tenenmos un atributo q es body haremos una validacion de precensia
  validates :body, presence: true
end
