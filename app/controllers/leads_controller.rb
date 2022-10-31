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
    @errors = []

    @lead = crm_client.find_lead_by_id(params[:id])
    @installer = Employee.find_by_name(@lead.installed_by)

    @errors << "Installer #{@lead.installed_by} not found" if @installer.nil?

    render 'errors/not_found', :status => '404' if @lead.nil?
  end

  def book_appointment
    @errors = []

    @lead = crm_client.find_lead_by_id(params[:id])

    @installer = Employee.find_by_name(@lead.installed_by)
    softener_image = Product.main_photo_for(@lead.water_softener_model.downcase)

    @errors << "Installer '#{@lead.installed_by}' not found" if @installer.nil?
    @errors << "Softener Image for '#{@lead.water_softener_model}' not found" if softener_image.nil?

    if @errors.any?
      render :show and return
    end

    year, month, day = @lead.installation_date.split('-').map(&:to_i)
    start_time = DateTime.new(year, month, day, *params[:start_time].split(':').map(&:to_i))
    end_time = start_time + params[:appointment_duration].to_i.hours

    calendar_client.schedule(
      start_time: start_time,
      end_time: end_time,
      calendar_id: @installer.calendar_id,
      description: "Phone: #{@lead.phone}, What3Words: #{@lead.what3words}",
      summary: "[TEST]: #{@lead.full_name}",
      location: @lead.address
    )

    ContactMailer.with(
      lead: @lead,
      installer: @installer,
      start_time: start_time,
      softener_image: softener_image
    ).installation_email.deliver_later

    ContactMailer.with(lead: @lead, installer: @installer).survey_email.deliver_later

    redirect_to :leads
  end
end
