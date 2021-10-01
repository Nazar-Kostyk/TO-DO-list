# frozen_string_literal: true

module ToDoLists
  class DestroyParamsValidator < Common::BaseValidator
    params(Common::Schemas::OnlyIdParamSchema)

    register_macro(:uuid_format) do
      key.failure(:invalid_format, field: :id, format_name: :UUID) unless UUID_FORMAT.match?(value)
    end

    rule(:id).validate(:uuid_format)
  end
end
