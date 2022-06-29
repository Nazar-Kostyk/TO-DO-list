# frozen_string_literal: true

module Schemas
  module Tasks
    ListOfTasksSchema = Dry::Schema.Params do
      required(:to_do_list_id).filled(:string)
    end
  end
end
