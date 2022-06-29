# frozen_string_literal: true

module ToDoLists
  class CreateParamsValidator < BaseValidator
    params do
      required(:title).maybe(:string)
      optional(:description).maybe(:string)
    end

    rule(:title).validate(min_length: ToDoList::TITLE_MIN_LENGTH)
    rule(:title).validate(max_length: ToDoList::TITLE_MAX_LENGTH)
  end
end
