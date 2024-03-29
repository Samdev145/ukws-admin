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

  def send_customer_email(sender, lead, test_mode = nil)
    softener_name = lead.water_softener_model.downcase

    ContactMailer.with(
      from: sender.email,
      lead: lead,
      installer: employee,
      employee: sender,
      start_time: start_time.to_s,
      product: Product.find_by_lowercase_name(softener_name),
      test_mode: test_mode
    ).installation_email.deliver_later
  end

  def send_survey_email(sender, lead, test_mode = nil)
    ContactMailer.with(
      sender: sender,
      lead: lead,
      test_mode: test_mode
    ).survey_email.deliver_later
  end

  def add_to_calendar(calendar_client, lead, test_mode = nil)
    summary = "#{lead.full_name} - #{lead.phone}"

    calendar_client.schedule(
      start_time: start_time,
      end_time: end_time,
      calendar_id: employee.calendar_id,
      description: "What3Words: #{lead.what3words}",
      summary: summary,
      location: lead.address
    )
  end
end
