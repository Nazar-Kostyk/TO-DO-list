# frozen_string_literal: true

class BaseService
  def build_success_response(payload)
    OpenStruct.new({ success?: true, payload: payload })
  end

  def build_failure_response(error)
    OpenStruct.new({ success?: false, error: error })
  end

  def error_details_by_translation_key(translation_key)
    {
      code: 401,
      title: I18n.t("error_messages.#{translation_key}.title", default: ''),
      detail: I18n.t("error_messages.#{translation_key}.detail", default: '')
    }.compact_blank
  end
end
