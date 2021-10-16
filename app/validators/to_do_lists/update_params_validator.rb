# frozen_string_literal: true

module ToDoLists
  class UpdateParamsValidator < BaseValidator
    params do
      required(:id).filled(:string)
      optional(:title).maybe(:string)
      optional(:description).maybe(:string)
    end

    rule(:id).validate(:uuid_format)

    rule(:title).validate(max_length: ToDoList::TITLE_MAX_LENGTH)
  end
end
