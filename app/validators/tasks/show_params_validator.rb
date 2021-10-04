# frozen_string_literal: true

module Tasks
  class ShowParamsValidator < Common::BaseValidator
    params(Schemas::Tasks::SingleTaskSchema)

    register_macro(:uuid_format) do
      key.failure(:invalid_format, field: :id, format_name: :UUID) unless UUID_FORMAT.match?(value)
    end

    rule(:to_do_list_id).validate(:uuid_format)

    rule(:id).validate(:uuid_format)
  end
end
