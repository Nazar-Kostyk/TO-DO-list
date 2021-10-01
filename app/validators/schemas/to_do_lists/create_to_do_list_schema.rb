# frozen_string_literal: true

module Schemas
  module ToDoLists
    CreateToDoListSchema = Dry::Schema.Params do
      optional(:title).maybe(:string)
      optional(:description).maybe(:string)
    end
  end
end
