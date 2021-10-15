# frozen_string_literal: true

module Actions
  module Tasks
    class ChangePositionOfTask < BaseActionService
      attr_reader :user, :params

      def initialize(user, params)
        @user = user
        @params = params
      end

      def call
        return validation_errors if validator.failure?

        task = find_task

        task.update_position(params[:new_position]) ? build_success_response(task) : build_database_error
      end

      private

      def validator
        @validator ||= ::Tasks::ChangePositionParamsValidator.new.call(params)
      end

      def validation_errors
        build_validation_errors(validator.errors.to_h)
      end

      def find_task
        to_do_list = user.to_do_lists.find(params[:to_do_list_id])
        to_do_list.tasks.find(params[:id])
      end
    end
  end
end
