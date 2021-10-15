# frozen_string_literal: true

module Actions
  module Tasks
    class GetListOfTasks < BaseService
      attr_reader :user, :params

      def initialize(user, params)
        @user = user
        @params = params
      end

      def call
        return validation_errors if validator.failure?

        tasks = retrieve_tasks

        build_success_response(tasks)
      end

      private

      def validator
        @validator ||= ::Tasks::IndexParamsValidator.new.call(params)
      end

      def validation_errors
        build_validation_errors_response(validator.errors.to_h)
      end

      def retrieve_tasks
        to_do_list = user.to_do_lists.find(params[:to_do_list_id])
        to_do_list.tasks.order(:position)
      end
    end
  end
end
