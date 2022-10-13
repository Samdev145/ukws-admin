class LeadsController < ApplicationController
  def index
    @session_details = session[:zoho]

    if params[:search]
      @leads = crm_client.leads(email: params[:search])
    end
  end

  def show
    @lead = crm_client.find_lead_by_id(params[:id])
  end

  def send_email
    @installer = Employee.find(params[:installer_id])
    @lead = crm_client.find_lead_by_id(params[:id])
    @softener_image = Product.find_by_name(@lead.water_softener_model.downcase)
                       .find_attachment_by_filename(:main_photo)

    email_template = params[:email_template].downcase
    
    ContactMailer.with(lead: @lead, installer: @installer)
                 .send("#{email_template}_email").deliver_now

    redirect_to :leads
  end

  def book_appointment
    employee = Employee.find(params[:employee_id])

    @lead = crm_client.find_lead_by_id(params[:id])

    year, month, day = @lead.installation_date.split('-').map(&:to_i)
    start_time = DateTime.new(year, month, day, params[:start_time].to_i)
    end_time = start_time + params[:appointment_duration].to_i.hours

    calendar_client.schedule(
      start_time: start_time,
      end_time: end_time,
      calendar_id: employee.calendar_id,
      description: "Phone: #{@lead.phone}, What3Words: #{@lead.what3words}",
      summary: "[TEST]: #{@lead.full_name}",
      location: @lead.address
    )

    redirect_to :leads
  end
end