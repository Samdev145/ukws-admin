# frozen_string_literal: true

module Sage
  class SageError < StandardError; end
  class RecordNotCreatedError < SageError; end
  class RecordNotFoundError < SageError; end
end
