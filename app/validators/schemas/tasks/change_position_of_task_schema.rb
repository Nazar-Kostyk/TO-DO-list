# frozen_string_literal: true

module Schemas
  module Tasks
    ChangePositionOfTaskSchema = Dry::Schema.Params do
      required(:to_do_list_id).filled(:string)
      required(:id).filled(:string)
      required(:new_position).filled(:integer)
    end
  end
end
