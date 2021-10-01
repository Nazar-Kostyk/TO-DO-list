# frozen_string_literal: true

module ToDoLists
  class CreateParamsValidator < Common::BaseValidator
    params(Schemas::ToDoLists::CreateToDoListSchema)

    register_macro(:max_length) do |macro:|
      max = macro.args[0]

      key.failure(:exceeds_maximum_length, field: key.path.keys[0], length: max) if value && value.size > max
    end

    rule(:title).validate(max_length: ToDoList::TITLE_MAX_LENGTH)
  end
end
