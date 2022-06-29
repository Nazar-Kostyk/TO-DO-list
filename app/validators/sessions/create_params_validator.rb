# frozen_string_literal: true

module Sessions
  class CreateParamsValidator < BaseValidator
    params do
      required(:email).filled(:string)
      required(:password).filled(:string)
    end

    rule(:email).validate(:email_format)
  end
end
