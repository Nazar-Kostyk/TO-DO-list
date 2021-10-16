# frozen_string_literal: true

module Tasks
  class DeleteParamsValidator < BaseValidator
    params do
      required(:to_do_list_id).filled(:string)
      required(:id).filled(:string)
    end

    rule(:to_do_list_id).validate(:uuid_format)

    rule(:id).validate(:uuid_format)
  end
end
