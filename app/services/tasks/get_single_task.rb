# frozen_string_literal: true

module Tasks
  class GetSingleTask < BaseService
    attr_reader :user, :params

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      return validation_errors if validator.failure?

      task = find_task

      build_success_response(data: task)
    end

    private

    def validator
      @validator ||= Tasks::ShowParamsValidator.new.call(params)
    end

    def validation_errors
      build_failure_response(data: validator.errors.to_h)
    end

    def find_task
      to_do_list = user.to_do_lists.find(params[:to_do_list_id])
      to_do_list.tasks.find(params[:id])
    end
  end
end
