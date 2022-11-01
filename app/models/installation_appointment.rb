# frozen_string_literal: true

class InstallationAppointment < Appointment
  def self.build_new(employee:, lead:, start_time:, end_time:)
    new(
      employee: employee,
      customer_email: lead.email,
      customer_type: 'Lead',
      start_time: start_time,
      end_time: end_time,
      crm_id: lead.id
    )
  end

  def send_customer_email(lead)
    softener_name = lead.water_softener_model.downcase

    ContactMailer.with(
      lead: lead,
      installer: employee,
      start_time: start_time,
      softener_image: Product.main_photo_for(softener_name)
    ).installation_email.deliver_later
  end

  def send_survey_email(lead)
    ContactMailer.with(
      lead: lead, installer: employee
    ).survey_email.deliver_later
  end

  def add_to_calendar(calendar_client, lead)
    calendar_client.schedule(
      start_time: start_time.to_datetime,
      end_time: end_time.to_datetime,
      calendar_id: employee.calendar_id,
      description: "Phone: #{lead.phone}, What3Words: #{lead.what3words}",
      summary: "[TEST]: #{lead.full_name}",
      location: lead.address
    )
  end
end
