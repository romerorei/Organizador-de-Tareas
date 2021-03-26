# rails g mailer ParticipantMailer 

class ParticipantMailer < ApplicationMailer
    # el objectivo de este mail es evniar un notificacion de q una tarea a sido creada
    def new_task_email
        @user = params[:user]
        @task = params[:task]

        #el metodo mail viene heredado de ApplicationMailer
        # se parametriza con to: destinatario y subject el asunto
        mail to: @user.email, subject: 'Tarea Asigada'
        
    end
end
