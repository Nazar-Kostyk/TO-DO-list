# frozen_string_literal: true

module Common
  class BaseValidator < Dry::Validation::Contract
    EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP
    UUID_FORMAT = /(^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$)/

    config.messages.backend = :i18n

    register_macro(:min_length) do |macro:|
      min = macro.args[0]

      key.failure(:under_minimum_length, field: :email, length: min) if value.size < min
    end

    register_macro(:max_length) do |macro:|
      max = macro.args[0]

      key.failure(:exceeds_maximum_length, field: :email, length: max) if value.size > max
    end

    register_macro(:email_format) do
      key.failure(:invalid, field: :email) unless EMAIL_FORMAT.match?(value)
    end

    register_macro(:uuid_format) do
      key.failure(:invalid, field: :email) unless UUID_FORMAT.match?(value)
    end

    register_macro(:email_uniqueness) do
      key.failure(:not_unique, field: :email) if !rule_error?(:email) && User.exists?(email: value)
    end
  end
end
