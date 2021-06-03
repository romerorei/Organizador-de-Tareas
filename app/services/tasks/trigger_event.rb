class Tasks::TriggerEvent
    def call(task, event) # dos campos event, task
      task.send "#{event}!"
      # esto se puede plantaer asi task.start osea el nombre del evento
      # con esto el istema queda preparado para escalamiento
      [true, 'successful']
    rescue => e
      Rails.logger.error e
      [false, 'failed']
    end
  end