# frozen_string_literal: true

module Actions
  module ToDoLists
    class UpdateToDoList < BaseActionService
      attr_reader :user, :params

      def initialize(user, params)
        @user = user
        @params = params
      end

      def call
        return validation_errors if validator.failure?

        to_do_list = find_to_do_list

        if to_do_list.update(params.slice(:title, :description))
          build_success_response(to_do_list)
        else
          build_database_error
        end
      end

      private

      def validator
        @validator ||= ::ToDoLists::UpdateParamsValidator.new.call(params)
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
