# frozen_string_literal: true

module ToDoLists
  module Show
    class ShowParamsValidator < Common::BaseValidator
      params(Common::Schemas::ToDoLists::ShowToDoListSchema)

      register_macro(:uuid_format) do
        key.failure(:invalid_format, field: :id, format_name: :UUID) unless UUID_FORMAT.match?(value)
      end

      rule(:id).validate(:uuid_format)
    end
  end
end
