# frozen_string_literal: true

module Schemas
  module Tasks
    CreateTaskSchema = Dry::Schema.Params do
      required(:to_do_list_id).filled(:string)
      optional(:title).filled(:string)
    end
  end
end
