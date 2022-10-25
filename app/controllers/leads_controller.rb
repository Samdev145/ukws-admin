# frozen_string_literal: true

class LeadsController < ApplicationController
  def index
    @session_details = session[:zoho]

    if params[:search] && params[:search].present?
      @leads = crm_client.leads(email: params[:search])

      if @leads.empty?
        flash.now[:alert] = 'No leads could be found by matching the email you provided'
      end
    end
  end

  def show
    @lead = crm_client.find_lead_by_id(params[:id])

    render 'errors/not_found', :status => '404' if @lead.nil?
  end

  def send_email
    lead = crm_client.find_lead_by_id(params[:id])
    installer = Employee.find_by_name(lead.installed_by)

    softener_image = Product.find_by_name(lead.water_softener_model.downcase)
                            .find_attachment_by_filename(:main_photo)

    year, month, day = lead.installation_date.split('-').map(&:to_i)
    start_time = DateTime.new(year, month, day, *params[:start_time].split(':').map(&:to_i))
    end_time = start_time + params[:appointment_duration].to_i.hours

    ContactMailer.with(
      lead: lead,
      installer: installer,
      start_time: start_time,
      softener_image: softener_image
    ).installation_email.deliver_later

    ContactMailer.with(
      lead: lead,
      installer: installer
    ).survey_email.deliver_later

    redirect_to :leads
  end

  def book_appointment
    employee = Employee.find(params[:employee_id])

    lead = crm_client.find_lead_by_id(params[:id])
    installer = Employee.find_by_name(lead.installed_by)

    softener_image = Product.find_by_name(lead.water_softener_model.downcase)
                            .find_attachment_by_filename(:main_photo)

    year, month, day = lead.installation_date.split('-').map(&:to_i)
    start_time = DateTime.new(year, month, day, *params[:start_time].split(':').map(&:to_i))
    end_time = start_time + params[:appointment_duration].to_i.hours

    ContactMailer.with(
      lead: lead,
      installer: installer,
      start_time: start_time,
      softener_image: softener_image
    ).installation_email.deliver_later

    ContactMailer.with(
      lead: lead,
      installer: installer
    ).survey_email.deliver_later

    calendar_client.schedule(
      start_time: start_time,
      end_time: end_time,
      calendar_id: employee.calendar_id,
      description: "Phone: #{lead.phone}, What3Words: #{lead.what3words}",
      summary: "[TEST]: #{lead.full_name}",
      location: lead.address
    )

    redirect_to :leads
  end
end
