# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  default from: 'spthomas145@gmail.com'
  helper :mailer

  def installation_email
    @lead = params[:lead]
    @installer = params[:installer]
    @start_time = params[:start_time]
    @product = params[:product]

    mail(
      to: email_to(@lead, params[:test_mode]),
      subject: 'Installation Appointment'
    )
  end

  def survey_email
    @lead = params[:lead]
    @installer = params[:installer]

    file_storage_client = FileStorage::Client.new(FileStorage::Session.new)
    survey_image_folder = file_storage_client.find_folder("/Customer%20Photos/#{@lead.email}/survey")
    images = survey_image_folder.children
    images.each do |img|
      response = img.download_file
      attachments[img.name.to_s] = response.parsed_response
    end

    mail(
      to: email_to(@lead, params[:test_mode]),
      subject: 'Survey Details'
    )
  end

  private

  def email_to(record, test_mode=nil)
    return record.email if test_mode.nil?

    ENV.fetch('EMAIL_TEST_ADDRESS')
  end
end
