# frozen_string_literal: true

module Tasks
  class DestroyTask < BaseService
    attr_reader :user, :params

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      return validation_errors if validator.failure?

      task = find_task

      task.destroy_record ? resource_successfully_destroyed : build_database_error_response
    end

    private

    def validator
      @validator ||= ::Tasks::DestroyParamsValidator.new.call(params)
    end

    def validation_errors
      build_validation_errors_response(validator.errors.to_h)
    end

    def find_task
      to_do_list = user.to_do_lists.find(params[:to_do_list_id])
      to_do_list.tasks.find(params[:id])
    end

    def resource_successfully_destroyed
      build_success_response(I18n.t('notifications.resource_destroyed'))
    end
  end
end
