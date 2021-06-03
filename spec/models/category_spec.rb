require 'rails_helper'

RSpec.describe Category, type: :model do
   # esto es para asegurarnos que la clase cateogira si sea un mongoid document
   # que tenga esta linea en categy.rb (en el modelo) include Mongoid::Document
   it { is_expected.to be_mongoid_document } 
 
  # esto es para asegurarnos de que tega timestamps
  #que tenga esta linea en categy.rb (en el modelo) include Mongoid::Timestamps
  it { is_expected.to have_timestamps }

  #con esto comprobamos q el modelo tenga campos name y description y que sus tipo de datos sean string
  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to have_field(:description).of_type(String) }

  # esto comprueba q el modelo tenga relaciones has_many
  it { is_expected.to have_many :tasks }

# esto prueba las validaciones del modelo
# que tenga validacion de presneca
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }

  #que tenga validacion de unicidad
  it { is_expected.to validate_uniqueness_of(:name) }

end
