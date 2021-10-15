# frozen_string_literal: true

module Actions
  module Tasks
    class CreateTask < BaseActionService
      attr_reader :user, :params

      def initialize(user, params)
        @user = user
        @params = params
      end

      def call
        return validation_errors if validator.failure?

        task = Task.new(model_params)

        task.save ? build_success_response(task) : build_database_error
      end

      private

      def validator
        @validator ||= ::Tasks::CreateParamsValidator.new.call(params)
      end

      def validation_errors
        build_validation_errors(validator.errors.to_h)
      end

      def model_params
        params.merge({ position: to_do_list.tasks.size })
      end

      def to_do_list
        user.to_do_lists.find(params[:to_do_list_id])
      end
    end
  end
end
