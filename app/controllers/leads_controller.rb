# frozen_string_literal: true

class LeadsController < ApplicationController
  before_action :authenticate_calendar_client_user, only: :book_appointment
  before_action :set_lead, except: :index
  before_action :set_installer, except: :index

  def index
    @session_details = session[:zoho]

    return unless params[:search]&.present?

    @leads = crm_client.leads(email: params[:search])

    flash.now[:alert] = 'No leads could be found by matching the email you provided' if @leads.empty?
  end

  def show
    @errors = []

    @errors << "Installer #{@lead.installed_by} not found" if @installer.nil?
  end

  def book_appointment
    Time.zone = @installer.time_zone

    set_start_time

    @appointment = InstallationAppointment.build_new(
      employee: @installer,
      lead: @lead,
      start_time: @start_time,
      end_time: @start_time + params[:appointment_duration].to_i.hours
    )

    if @appointment.save
      @appointment.send_customer_email(params[:email_from], @lead, params[:test])
      @appointment.send_survey_email(params[:email_from], @lead, params[:test])
      @appointment.add_to_calendar(calendar_client, @lead, params[:test])

      flash[:success] = 'Installation has succesfully been booked'

      redirect_to :leads
    else
      render :show
    end
  end

  def installation_email
    @employee = Employee.find_by_email(params[:email_from])

    Time.zone = @installer.time_zone

    set_start_time
    set_product

    render 'contact_mailer/installation_email'
  end

  def send_quotation
    Time.zone = @installer.time_zone

    set_start_time
    set_product

    ContactMailer.with(
      from: params[:email_from],
      lead: @lead,
      installer: @installer,
      start_time: @start_time.to_s,
      product: @product,
      test_mode: params[:test]
    ).quotation_email.deliver_later

    flash[:success] = 'The quotation email has been sent'

    redirect_to :leads
  end

  def quotation_email
    @employee = Employee.find_by_email(params[:email_from])

    Time.zone = @installer.time_zone

    set_start_time
    set_product

    render 'contact_mailer/quotation_email'
  end

  private

  def set_lead
    @lead = crm_client.find_lead_by_id(params[:id])
    render('errors/not_found', status: '404') and return if @lead.nil?
  end

  def set_installer
    @installer = Employee.find_by_name(@lead.installed_by)
  end

  def set_product
    @product = Product.find_by_lowercase_name(@lead.water_softener_model.downcase)
  end

  def set_start_time
    year, month, day = @lead.installation_date.split('-').map(&:to_i)
    @start_time = Time.zone.local(year, month, day, *params[:start_time].split(':').map(&:to_i))
  end
end
