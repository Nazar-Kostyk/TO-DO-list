# frozen_string_literal: true

module Tasks
  class ChangePositionParamsValidator < BaseValidator
    params do
      required(:to_do_list_id).filled(:string)
      required(:id).filled(:string)
      required(:new_position).filled(:integer)
    end

    rule(:to_do_list_id).validate(:uuid_format)

    rule(:id).validate(:uuid_format)

    rule(:new_position).validate(min_value: 0)
    rule(:new_position) do
      if !rule_error?(:to_do_list_id) && !rule_error?(:id) && !rule_error?(:new_position) && Task.exists?(values[:id])
        max_allowed_position = ToDoList.find(values[:to_do_list_id]).tasks.maximum(:position)

        if value && value > max_allowed_position
          key.failure(:max_value, field: :new_position, number: max_allowed_position)
        end
      end
    end
  end
end
