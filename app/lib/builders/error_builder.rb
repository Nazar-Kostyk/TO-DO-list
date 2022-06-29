# frozen_string_literal: true

module Builders
  module ErrorBuilder
    def build_validation_errors_details(errors_hash)
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

    def build_error_by_translation_key(status:, translation_key:)
      {
        status: status,
        details: build_error_details_by_translation_key(translation_key)
      }
    end

    def build_error_details_by_translation_key(translation_key)
      {
        title: I18n.t("error_messages.#{translation_key}.title", default: ''),
        detail: I18n.t("error_messages.#{translation_key}.detail", default: '')
      }.compact_blank
    end
  end
end
