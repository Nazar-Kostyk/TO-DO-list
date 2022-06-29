# frozen_string_literal: true

module Tasks
  class ChangePositionParamsValidator < Common::BaseValidator
    params(Schemas::Tasks::ChangePositionOfTaskSchema)

    register_macro(:uuid_format) do
      key.failure(:invalid_format, field: :id, format_name: :UUID) unless UUID_FORMAT.match?(value)
    end

    register_macro(:min_value) do |macro:|
      min = macro.args[0]

      key.failure(:min_value, field: key.path.keys[0], number: min) if value < min
    end

    rule(:to_do_list_id).validate(:uuid_format)

    rule(:id).validate(:uuid_format)

    rule(:new_position).validate(min_value: 0)
    rule(:new_position) do
      if !rule_error?(:to_do_list_id) && !rule_error?(:id) && !rule_error?(:new_position) && Task.exists?(values[:id])
        max_allowed_position = ToDoList.find(values[:to_do_list_id]).tasks.count - 1

        key.failure(:max_value, field: key.path.keys[0], number: max_allowed_position) if value > max_allowed_position
      end
    end
  end
end
