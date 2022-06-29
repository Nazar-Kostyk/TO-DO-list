# frozen_string_literal: true

module Tasks
  class CreateParamsValidator < BaseValidator
    params do
      required(:to_do_list_id).filled(:string)
      optional(:title).filled(:string)
    end

    rule(:to_do_list_id).validate(:uuid_format)

    rule(:title).validate(max_length: Task::TITLE_MAX_LENGTH)
  end
end
