require 'zoho/client'
require 'my_google/calendar'

CRM_CLIENT = Zoho::Client
CRM_CLIENT::Provider = 'zoho'

CALENDAR_CLIENT = MyGoogle::Calendar
CALENDAR_CLIENT::Provider = 'google_oauth2'