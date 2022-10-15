require 'zoho/client'
require 'my_google/calendar'

CRM = Zoho
CRM::Provider = 'zoho'

CALENDAR_CLIENT = MyGoogle::Calendar
CALENDAR_CLIENT::Provider = 'google_oauth2'