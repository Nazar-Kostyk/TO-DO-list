# frozen_string_literal: true

module ToDoLists
  class UpdateParamsValidator < Common::BaseValidator
    params(Common::Schemas::ToDoLists::UpdateToDoListSchema)

    register_macro(:uuid_format) do
      key.failure(:invalid_format, field: :id, format_name: :UUID) unless UUID_FORMAT.match?(value)
    end

    register_macro(:max_length) do |macro:|
      max = macro.args[0]

      key.failure(:exceeds_maximum_length, field: key.path.keys[0], length: max) if value && value.size > max
    end

    rule(:id).validate(:uuid_format)

    rule(:title).validate(max_length: ToDoList::TITLE_MAX_LENGTH)
  end
end
