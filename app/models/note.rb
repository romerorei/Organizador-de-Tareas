
# rails g model Note body:text user:references task:references
class Note
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :body, type: String

  belongs_to :user
  belongs_to :task

  # como solo tenenmos un atributo q es body haremos una validacion de precensia
  validates :body, presence: true
end
