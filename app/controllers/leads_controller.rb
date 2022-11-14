# frozen_string_literal: true

class LeadsController < ApplicationController
  before_action :authenticate_calendar_client_user, only: :book_appointment

  def index
    @session_details = session[:zoho]

    return unless params[:search]&.present?

    @leads = crm_client.leads(email: params[:search])

    flash.now[:alert] = 'No leads could be found by matching the email you provided' if @leads.empty?
  end

  def show
    @errors = []

    @lead = crm_client.find_lead_by_id(params[:id])

    render('errors/not_found', status: '404') and return if @lead.nil?

    @installer = Employee.find_by_name(@lead.installed_by)

    @errors << "Installer #{@lead.installed_by} not found" if @installer.nil?
  end

  def book_appointment
    @lead = crm_client.find_lead_by_id(params[:id])
    @installer = Employee.find_by_name(@lead.installed_by)

    Time.zone = @installer.time_zone

    year, month, day = @lead.installation_date.split('-').map(&:to_i)
    start_time = Time.zone.local(year, month, day, *params[:start_time].split(':').map(&:to_i))
    end_time = start_time + params[:appointment_duration].to_i.hours

    @appointment = InstallationAppointment.build_new(
      employee: @installer,
      lead: @lead,
      start_time: start_time,
      end_time: end_time
    )

    if @appointment.save

      @appointment.send_customer_email(@lead, params[:test])
      @appointment.send_survey_email(@lead, params[:test])
      @appointment.add_to_calendar(calendar_client, @lead, params[:test])

      flash[:success] = 'Installation has succesfully been booked'

      redirect_to :leads
    else
      render :show
    end
  end

  def installation_email
    @lead = crm_client.find_lead_by_id(params[:id])
    @installer = Employee.find_by_name(@lead.installed_by)

    Time.zone = @installer.time_zone

    year, month, day = @lead.installation_date.split('-').map(&:to_i)
    @start_time = Time.zone.local(year, month, day, *params[:start_time].split(':').map(&:to_i))

    @product = Product.find_by_lowercase_name(@lead.water_softener_model.downcase)

    render 'contact_mailer/installation_email'
  end
end
