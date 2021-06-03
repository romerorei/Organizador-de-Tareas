class Tasks::SendEmail
    #el metodo call es el q estamos llaamando en la prueba cuando recibimos el servcios
    # ver send_email_spec.rb ahi esta el metodo call
    # y hace refencia hacia la tarea
    def call(task)
        #las dos lineas de abajo antes estaban directas en el modelo task.rb ahora sun un services object
        (task.participants + [task.owner]).each do |user|
          ParticipantMailer.with(user: user, task: task).new_task_email.deliver!
        end
        [true, 'successful'] #definicions de respuiesta
      rescue => e # este es un sistema muy muy basico de gestion de errores 
        
        
        Rails.logger.error e
        [false, 'failed']
    end
end