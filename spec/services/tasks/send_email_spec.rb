require 'rails_helper'

RSpec.describe Tasks::SendEmail do
    #los let son para definir una tarea valida y se les va a enviar al as pruebas como unas variables
    # el motod build es del factoryBot
    let(:participants_count) { 4 }
    let(:task) { build(:task_with_participants, participants_count: participants_count) }

    #described_class hace referencia al la clase q tratamos arribas el Tasks::SendEmail
    subject(:service) { described_class.new }
    # siempre q citemos al subject vamos a hacer refencia a una instancia del servicio Tasks::SendEmail

    describe '#call' do #metodo de instancia call
        context 'Con una tarea valida' do

          #el before es para pasarle la referencia a la tarea definida arriba antes de ejecutar el bloque de abajo
          before(:each) { task.save }
    
          it 'Deberia ser exitosa' do
                #service es el subject de arriba y call es un metodo disponible de ruby
            success, message = service.call task
            expect(success).to eq true
            expect(message).to eq 'successful'
          end
        end
    
        context 'Con una taera nula' do
          it 'Deberia retornar fallida' do
            success, message = service.call nil
            expect(success).to eq false
            expect(message).to eq 'failed'
          end
        end
    end
end







