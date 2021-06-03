# rails  g  sucker_punch:job tasks/send_email
class Tasks::SendEmailJob
  include SuckerPunch::Job

  def perform(task_id)
    task = Task.find(task_id)
    Tasks::SendEmail.new.call task
    #metodo new para instanciarlo y call para llamarlo
    # esto hace q no utilicemo el servicio de forma directa si no a traves de un job
  end
end