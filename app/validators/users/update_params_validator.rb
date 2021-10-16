# frozen_string_literal: true

module Users
  class UpdateParamsValidator < BaseValidator
    params do
      optional(:name).filled(:string)
      optional(:surname).filled(:string)
      optional(:email).filled(:string)
      required(:current_password).filled(:string)
      optional(:new_password).filled(:string)
      optional(:new_password_confirmation).filled(:string)
    end

    register_macro(:email_uniqueness) do
      key.failure(:not_unique, field: :email) if value && !rule_error?(:email) && User.exists?(email: value)
    end

    register_macro(:passwords_match) do
      key.failure(:passwords_do_not_match) if values[:new_password].present? && value != values[:new_password]
    end

    rule(:name).validate(max_length: User::NAME_MAX_LENGTH)

    rule(:surname).validate(max_length: User::SURNAME_MAX_LENGTH)

    rule(:email).validate(min_length: User::EMAIL_MIN_LENGTH)
    rule(:email).validate(max_length: User::EMAIL_MAX_LENGTH)
    rule(:email).validate(:email_format)
    rule(:email).validate(:email_uniqueness)

    rule(:new_password).validate(min_length: User::PASSWORD_MIN_LENGTH)
    rule(:new_password).validate(max_length: User::PASSWORD_MAX_LENGTH)

    rule(:new_password_confirmation).validate(:passwords_match)
  end
end
