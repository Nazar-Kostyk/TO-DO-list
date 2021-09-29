# frozen_string_literal: true

module Common
  module Schemas
    module ToDoLists
      UpdateToDoListSchema = Dry::Schema.Params do
        required(:id).filled(:string)
        optional(:title).maybe(:string)
        optional(:description).maybe(:string)
      end
    end
  end
end
