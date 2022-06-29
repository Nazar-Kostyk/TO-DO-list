# frozen_string_literal: true

module Tasks
  class IndexParamsValidator < BaseValidator
    params do
      required(:to_do_list_id).filled(:string)
    end

    rule(:to_do_list_id).validate(:uuid_format)
  end
end
