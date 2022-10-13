class ContactMailer < ApplicationMailer
  default from: 'spthomas145@gmail.com'

  def installation_email
    @lead = params[:lead]
    @installer = params[:installer]
    mail(to: @contact.customer_email, subject: 'Installation')
  end
  
  def service_email
    @lead = params[:lead]
    mail(to: @contact.customer_email, subject: 'Service')
  end

end
