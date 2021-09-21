# frozen_string_literal: true

module Users
  module Update
    class UpdateParamsValidator < Common::BaseValidator
      params(Common::Schemas::UpdateUserSchema)

      register_macro(:min_length) do |macro:|
        min = macro.args[0]

        key.failure(:under_minimum_length, field: key.path.keys[0], length: min) if key? && value.size < min
      end

      register_macro(:max_length) do |macro:|
        max = macro.args[0]

        key.failure(:exceeds_maximum_length, field: key.path.keys[0], length: max) if key? && value.size > max
      end

      register_macro(:uuid_format) do
        key.failure(:invalid, field: key.path.keys[0]) if key? && !UUID_FORMAT.match?(value)
      end

      register_macro(:email_format) do
        key.failure(:invalid, field: :email) if key? && !EMAIL_FORMAT.match?(value)
      end

      register_macro(:email_uniqueness) do
        key.failure(:not_unique, field: :email) if key? && !rule_error?(:email) && User.exists?(email: value)
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

      rule(:new_password_confirmation).validate(:passwords_match)
    end
  end
end
