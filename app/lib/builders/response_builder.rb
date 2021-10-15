# frozen_string_literal: true

module Builders
  module ResponseBuilder
    include ErrorBuilder

    def build_success_response(payload)
      OpenStruct.new({ success?: true, payload: payload })
    end

    def build_failure_response(error)
      OpenStruct.new({ success?: false, error: error })
    end

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

    def build_error_response_by_translation_key(status:, translation_key:)
      build_failure_response(
        build_error_by_translation_key(
          status: status,
          translation_key: translation_key
        )
      )
    end
  end
end
