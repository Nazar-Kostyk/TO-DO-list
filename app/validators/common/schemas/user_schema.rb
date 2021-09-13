module Common
  module Schemas
    UserSchema = Dry::Schema.Params do
      required(:name).filled(:string)
      required(:surname).filled(:string)
      required(:email).filled(:string)
      required(:password).filled(:string)
      required(:password_confirmation).filled(:string)
    end
  end
end
