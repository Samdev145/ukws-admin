class ContactMailer < ApplicationMailer
  default from: 'spthomas145@gmail.com'

  def installation_email
    @lead = params[:lead]
    @installer = params[:installer]
    @start_time = params[:start_time]
    @softener_image = params[:softener_image]
    mail(to: @lead.email, subject: 'Installation')
  end
  
  def service_email
    @lead = params[:lead]
    mail(to: @lead.email, subject: 'Service')
  end
end
