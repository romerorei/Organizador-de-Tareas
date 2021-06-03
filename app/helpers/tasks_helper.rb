module TasksHelper
    def avalible_events_for(task) #video 32 de intermedio de rails
        task.aasm.permitted_transitions.map { |t| t[:event] }    
    end
end
