# frozen_string_literal: true

module Actions
  class BaseActionService
    def build_success_response(payload)
      OpenStruct.new({ success?: true, payload: payload })
    end

    def build_failure_response(error)
      OpenStruct.new({ success?: false, error: error })
    end

    def build_validation_errors(errors_hash)
      build_failure_response(
        {
          status: :bad_request,
          details: validation_errors_details(errors_hash)
        }
      )
    end

    def build_database_error
      build_failure_response(
        {
          status: :unprocessable_entity,
          details: error_details_by_translation_key('database_error')
        }
      )
    end

    def validation_errors_details(errors_hash)
      errors_hash.map do |attribute_name, error_details|
        error_details.map do |detail|
          {
            source: {
              pointer: "/data/attributes/#{attribute_name}"
            },
            detail: detail
          }
        end
      end.flatten
    end

    def error_details_by_translation_key(translation_key)
      {
        code: 422,
        title: I18n.t("error_messages.#{translation_key}.title", default: ''),
        detail: I18n.t("error_messages.#{translation_key}.detail", default: '')
      }.compact_blank
    end
  end
end
