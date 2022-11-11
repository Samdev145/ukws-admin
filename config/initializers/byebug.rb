# frozen_string_literal: true

if Rails.env.development? && ENV['MAIN_THREAD'] == 'true'
  require 'byebug/core'
  begin
    Byebug.start_server 'localhost', ENV.fetch('BYEBUG_SERVER_PORT', 8989).to_i
  rescue Errno::EADDRINUSE, Errno::EADDRNOTAVAIL
    Rails.logger.debug 'Byebug server already running'
  end
end
