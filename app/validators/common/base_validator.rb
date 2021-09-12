module Common
  class BaseValidator < Dry::Validation::Contract
    EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP.freeze
    UUID_FORMAT = /(^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$)/.freeze

    def follows_uuid_format?(value)
      UUID_FORMAT.match?(value)
    end

    def follows_email_format?(value)
      EMAIL_FORMAT.match?(value)
    end

    def email_is_unique?(email)
      !User.exists?(email: email)
    end
  end
end
