# frozen_string_literal: true

module Users
  module Create
    class CreateParamsValidator < Common::BaseValidator
      NAME_MAX_LENGTH = 255
      SURNAME_MAX_LENGTH = 255
      EMAIL_MIN_LENGTH = 5
      EMAIL_MAX_LENGTH = 64
      PASSWORD_MIN_LENGTH = 8
      PASSWORD_MAX_LENGTH = 64

      params(Common::Schemas::UserSchema)

      rule(:name) do
        if value.size > NAME_MAX_LENGTH
          key.failure(
            I18n.t('dry_validation.exceeds_maximum_length', field: :name, length: NAME_MAX_LENGTH)
          )
        end
      end

      rule(:surname) do
        if value.size > SURNAME_MAX_LENGTH
          key.failure(
            I18n.t('dry_validation.exceeds_maximum_length', field: :surname, length: SURNAME_MAX_LENGTH)
          )
        end
      end

      rule(:email) do
        if value.size < EMAIL_MIN_LENGTH
          key.failure(
            I18n.t('dry_validation.under_minimum_length', field: :email, length: EMAIL_MIN_LENGTH)
          )
        end
        if value.size > EMAIL_MAX_LENGTH
          key.failure(
            I18n.t('dry_validation.exceeds_maximum_length', field: :email, length: EMAIL_MAX_LENGTH)
          )
        end
        key.failure(I18n.t('dry_validation.invalid', field: :email)) unless follows_email_format?(value)
        key.failure(I18n.t('dry_validation.not_unique', field: :email)) if !rule_error? && !email_is_unique?(value)
      end

      rule(:password) do
        if value.size < PASSWORD_MIN_LENGTH
          key.failure(
            I18n.t('dry_validation.under_minimum_length', field: :password, length: PASSWORD_MIN_LENGTH)
          )
        end
        if value.size > PASSWORD_MAX_LENGTH
          key.failure(
            I18n.t('dry_validation.exceeds_maximum_length', field: :password, length: PASSWORD_MAX_LENGTH)
          )
        end
      end
    end
  end
end
