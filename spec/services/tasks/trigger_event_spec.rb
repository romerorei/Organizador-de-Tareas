require 'rails_helper'

RSpec.describe Tasks::TriggerEvent do
  let(:participants_count) { 4 }
  let(:task) { build(:task_with_participants, participants_count: participants_count) }

  subject(:service) { described_class.new }

  describe '#Call' do
    context 'Con una tarea Validad' do
      before(:each) { task.save }

      let(:event) { 'start' } # el nombre del evento 'start'

      it 'Deberia retornar success' do
        success, message = service.call task, event
        expect(success).to eq true
        expect(message).to eq 'successful'
        expect(task.status).to eq 'in_process'
        expect(task.transitions.count).to eq 1
      end
    end
  end
end