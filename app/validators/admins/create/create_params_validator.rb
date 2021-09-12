module Admins
  module Create
    class CreateParamsValidator < Common::BaseValidator
      params(Common::Schemas::UserSchema)

      rule(:name) do
        key.failure('Invalid name size')  if value.size > 255
      end

      rule(:surname) do
        key.failure('Invalid surname size') if value.size > 255
      end

      rule(:email) do
        key.failure('Invalid email size') if value.size < 5 || value.size > 64
        key.failure('Invalid email format') unless follows_email_format?(value)
        key.failure('Email is not unique') if !rule_error? && !email_is_unique?(value)
      end

      rule(:password) do
        key.failure('Invalid password size') if value.size < 8 || value.size > 64
      end
    end
  end
end
