# frozen_string_literal: true

module Common
  class BaseValidator < Dry::Validation::Contract
    EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP
    UUID_FORMAT = /(^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$)/

    config.messages.backend = :i18n
  end
end
