# frozen_string_literal: true

module Schemas
  module Tasks
    SingleTaskSchema = Dry::Schema.Params do
      required(:to_do_list_id).filled(:string)
      required(:id).filled(:string)
    end
  end
end
