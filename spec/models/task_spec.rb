# spec/models/task_spec.rb
# rails g rspec:model task
require 'rails_helper'

RSpec.describe Task, type: :model do
    
     # esto es para asegurarnos que la clase task si sea un mongoid document
   # que tenga esta linea en task.rb (en el modelo) include Mongoid::Document
   it { is_expected.to be_mongoid_document } 
 
   # esto es para asegurarnos de que tega timestamps
   #que tenga esta linea en task.rb (en el modelo) include Mongoid::Timestamps
   it { is_expected.to have_timestamps }
 
   #con esto comprobamos q el modelo tenga campos name y description y que sus tipo de datos sean string
   it { is_expected.to have_field(:name).of_type(String) }
   it { is_expected.to have_field(:description).of_type(String) }
   it { is_expected.to have_field(:due_date).of_type(Date) }
   it { is_expected.to have_field(:code).of_type(String) }
   # esto comprueba q el modelo tenga relaciones has_many, belong_to
   it { is_expected.to have_many :participating_users }
   it { is_expected.to belong_to :owner }
   it { is_expected.to belong_to :category }
   it { is_expected.to have_many :notes }
 
 # esto prueba las validaciones del modelo
 # que tenga validacion de presnecia
   it { is_expected.to validate_presence_of(:name) }
   it { is_expected.to validate_presence_of(:description) }
 
   #que tenga validacion de unicidad
   it { is_expected.to validate_uniqueness_of(:name) }


    describe '#save' do
        context "Con parametros de scratch osea desde cero" do
            #estos let de abajos viene de los factories/user de factories y factories/users
            let(:owner) { create :user }
            let(:category) { create :category }
            # usamos build para q el particiapn se construya y no se guarde si no que se guarde en la definicion de abajo en el subject 
            let(:participant_1) { build :participant, :responsible} 
            let(:participant_2) { build :participant, :follower}

            subject(:task) do
                # described_class.new es igual a Task.new y hace referencia RSpec.describe Task especificado arriba
                described_class.new(
                    name: 'Mi Tarea Scratch',
                    description: 'TEST TEST',
                    due_date: Date.today + 5.days,
                    category: category,
                    owner: owner,
                    participating_users: [participant_1, participant_2]
                )
            end
            it { is_expected.to be_valid } # esto comprueba que  los datos definidos son validos son validos

            context "after save" do 
                # despues de haber invocado el metodo 'save'
                # con esto probamos que el codigo este persistido y q tenga el codigo computado osea el callback de before_create :create_code
                # cuando se invoca task.save estamos llamando al subject mismo de arriba: subject(:task)
                before(:each) { task.save}  
                it { is_expected.to be_persisted }    
                
                it 'tiene un codigo computado' do
                    expect(task.code).to be_present  
                end
            end #context "after save" 
            
            context "con due_date en el pasado" do
                subject {task.tap { |t| t.due_date = Date.today - 1.day }}

                it { is_expected.to_not be_valid } 
            end
            

        end # context "Con parametros de scratch osea desde cero" 
        
        context "Con parametros de FactoryBot" do
            let(:participants_count) { 4 }
            subject(:task) { build(:task_with_participants, participants_count: participants_count) }
    
            it 'is persisted' do
                expect(task.save).to eq true
            end

            context 'after save' do
                before(:each) { task.save }

                it 'has all associated participants' do
                    expect(task.participating_users.count).to eq participants_count
                    expect(Participant.count).to eq participants_count
                end

            end 
        end
    end #describe '#save'

end #RSpec.describe Task,