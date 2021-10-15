# frozen_string_literal: true

module Actions
  module ToDoLists
    class GetSingleToDoList < BaseService
      attr_reader :user, :params

      def initialize(user, params)
        @user = user
        @params = params
      end

      def call
        return validation_errors if validator.failure?

        to_do_list = find_to_do_list

        build_success_response(to_do_list)
      end

      private

      def validator
        @validator ||= ::ToDoLists::ShowParamsValidator.new.call(params)
      end

      def validation_errors
        build_validation_errors_response(validator.errors.to_h)
      end

      def find_to_do_list
        user.to_do_lists.find(params[:id])
      end
    end
  end
end
