# frozen_string_literal: true

module MyGoogle
  class Session
    def initialize(session)
      @session = session
    end

    def token
      session['token']
    end

    def invalid_session?
      !valid_session?
    end

    private

    attr_reader :session

    def valid_session?
      return true unless token_expired?
    end

    def token_expired?
      Time.zone.now > Time.zone.at(session['expires_at'])
    end
  end
end
