# frozen_string_literal: true

class BaseService
  def build_success_response(data:)
    OpenStruct.new({ success?: true, payload: data })
  end

  def build_failure_response(data:)
    OpenStruct.new({ success?: false, error: data })
  end
end
