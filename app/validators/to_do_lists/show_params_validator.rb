# frozen_string_literal: true

module ToDoLists
  class ShowParamsValidator < BaseValidator
    params(Common::Schemas::OnlyIdParamSchema)

    rule(:id).validate(:uuid_format)
  end
end
