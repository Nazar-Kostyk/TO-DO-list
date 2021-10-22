# frozen_string_literal: true

class BaseValidator < Dry::Validation::Contract
  EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP
  UUID_FORMAT = /(^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$)/

  config.messages.backend = :i18n

  register_macro(:uuid_format) do
    key.failure(:invalid_format, field: key.path.keys[0], format_name: :UUID) if value && !UUID_FORMAT.match?(value)
  end

  register_macro(:email_format) do
    key.failure(:invalid_format, field: key.path.keys[0], format_name: :email) if value && !EMAIL_FORMAT.match?(value)
  end

  register_macro(:min_length) do |macro:|
    min = macro.args[0]

    key.failure(:under_minimum_length, field: key.path.keys[0], length: min) if value && value.size < min
  end

  register_macro(:max_length) do |macro:|
    max = macro.args[0]

    key.failure(:exceeds_maximum_length, field: key.path.keys[0], length: max) if value && value.size > max
  end

  register_macro(:min_value) do |macro:|
    min = macro.args[0]

    key.failure(:min_value, field: key.path.keys[0], number: min) if value && value < min
  end
end
