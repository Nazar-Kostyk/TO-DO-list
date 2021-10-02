# frozen_string_literal: true

module Schemas
  module Users
    UpdateUserSchema = Dry::Schema.Params do
      optional(:name).filled(:string)
      optional(:surname).filled(:string)
      optional(:email).filled(:string)
      required(:current_password).filled(:string)
      optional(:new_password).filled(:string)
      optional(:new_password_confirmation).filled(:string)
    end
  end
end
