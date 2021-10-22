# frozen_string_literal: true

class BaseService
  include Builders::ResponseBuilder

  def build_validation_errors_response(errors_hash)
    build_failure_response(
      {
        status: :bad_request,
        details: build_validation_errors_details(errors_hash)
      }
    )
  end

  def build_database_error_response
    build_error_response_by_translation_key(status: :unprocessable_entity, translation_key: 'database_error')
  end
end
