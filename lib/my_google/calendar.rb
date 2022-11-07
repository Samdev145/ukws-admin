# frozen_string_literal: true

module MyGoogle
  class Client
    def initialize(session)
      @session = session
      @calendar = ::Google::Apis::CalendarV3::CalendarService.new
      calendar.authorization = session.token
    end

    def schedule(opts = {})
      event = Google::Apis::CalendarV3::Event.new(
        summary: opts[:summary],
        location: opts[:location],
        description: opts[:description],
        start: event_time(opts[:start_time]),
        end: event_time(opts[:end_time])
      )

      calendar.insert_event(opts[:calendar_id], event)
    end

    def invalid_session?
      session.invalid_session?
    end

    private

    attr_reader :session, :calendar

    def event_time(time)
      Google::Apis::CalendarV3::EventDateTime.new(
        date_time: time,
        time_zone: 'Europe/London'
      )
    end
  end
end
