# frozen_string_literal: true

module MyGoogle
  class Calendar
    attr_reader :calendar

    def initialize(session)
      @calendar = ::Google::Apis::CalendarV3::CalendarService.new
      calendar.authorization = session['token']
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

    private

    def event_time(time)
      Google::Apis::CalendarV3::EventDateTime.new(
        date_time: time,
        time_zone: 'Europe/London'
      )
    end
  end
end
