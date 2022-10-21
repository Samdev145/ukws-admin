# frozen_string_literal: true

require 'zoho/client'
require 'my_google/calendar'
require 'microsoft_office365/client'

CRM = Zoho
CRM::Provider = 'zoho'

CALENDAR_CLIENT = MyGoogle::Calendar
CALENDAR_CLIENT::Provider = 'google_oauth2'

FileStorage = MicrosoftOffice365
FileStorage::Provider = 'microsoft_office365'
