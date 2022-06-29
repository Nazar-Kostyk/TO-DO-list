# frozen_string_literal: true

module Tasks
  class UpdateParamsValidator < Common::BaseValidator
    params(Schemas::Tasks::UpdateTaskSchema)

    register_macro(:uuid_format) do
      key.failure(:invalid_format, field: :id, format_name: :UUID) unless UUID_FORMAT.match?(value)
    end

    register_macro(:max_length) do |macro:|
      max = macro.args[0]

      key.failure(:exceeds_maximum_length, field: key.path.keys[0], length: max) if value && value.size > max
    end

    rule(:to_do_list_id).validate(:uuid_format)

    rule(:id).validate(:uuid_format)

    rule(:title).validate(max_length: Task::TITLE_MAX_LENGTH)
  end
end
