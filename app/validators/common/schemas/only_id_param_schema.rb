# frozen_string_literal: true

module Common
  module Schemas
    OnlyIdParamSchema = Dry::Schema.Params do
      required(:id).filled(:string)
    end
  end
end
