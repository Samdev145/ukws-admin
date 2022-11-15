# frozen_string_literal: true

if Rails.env.development? && ENV['THREAD_TYPE'] == ENV['BYEBUG_THREAD']
  require 'byebug/core'
  begin
    Byebug.start_server 'localhost', ENV.fetch('BYEBUG_SERVER_PORT', 8989).to_i
  rescue Errno::EADDRINUSE, Errno::EADDRNOTAVAIL
    Rails.logger.debug 'Byebug server already running'
  end
end
