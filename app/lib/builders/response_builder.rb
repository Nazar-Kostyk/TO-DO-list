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
