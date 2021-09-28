# frozen_string_literal: true

module Common
  module Schemas
    module ToDoLists
      ShowToDoListSchema = Dry::Schema.Params do
        required(:id).filled(:string)
      end
    end
  end
end
