# frozen_string_literal: true

module Common
  module Schemas
    module ToDoLists
      CreateToDoListSchema = Dry::Schema.Params do
        optional(:title).maybe(:string)
        optional(:description).maybe(:string)
      end
    end
  end
end
