# frozen_string_literal: true

module Admins
  module Create
    class CreateParamsValidator < Common::BaseValidator
      params(Common::Schemas::UserSchema)

      register_macro(:passwords_match) do
        key.failure(:passwords_do_not_match) if value != values[:password]
      end

      rule(:name).validate(max_length: Admin::NAME_MAX_LENGTH)
      
      rule(:surname).validate(max_length: Admin::SURNAME_MAX_LENGTH)
      
      rule(:email).validate(min_length: Admin::EMAIL_MIN_LENGTH)
      rule(:email).validate(max_length: Admin::EMAIL_MAX_LENGTH)
      rule(:email).validate(:email_format)
      rule(:email).validate(:email_uniqueness)
      
      rule(:password).validate(min_length: Admin::PASSWORD_MIN_LENGTH)
      rule(:password).validate(max_length: Admin::PASSWORD_MAX_LENGTH)

      rule(:password_confirmation).validate(:passwords_match)
    end
  end
end
