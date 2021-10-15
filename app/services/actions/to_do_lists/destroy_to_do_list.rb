# frozen_string_literal: true

module Actions
  module ToDoLists
    class DestroyToDoList < BaseActionService
      attr_reader :user, :params

      def initialize(user, params)
        @user = user
        @params = params
      end

      def call
        return validation_errors if validator.failure?

        to_do_list = find_to_do_list

        to_do_list.destroy ? build_success_response(I18n.t('notifications.resource_destroyed')) : build_database_error
      end

      private

      def validator
        @validator ||= ::ToDoLists::ShowParamsValidator.new.call(params)
      end

      def validation_errors
        build_validation_errors(validator.errors.to_h)
      end

      def find_to_do_list
        user.to_do_lists.find(params[:id])
      end
    end
  end
end
