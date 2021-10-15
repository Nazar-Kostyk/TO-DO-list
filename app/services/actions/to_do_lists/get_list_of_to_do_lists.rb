# frozen_string_literal: true

module Actions
  module ToDoLists
    class GetListOfToDoLists < BaseActionService
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def call
        to_do_lists = retrieve_to_do_lists

        build_success_response(to_do_lists)
      end

      private

      def validation_errors
        build_validation_errors(validator.errors.to_h)
      end

      def retrieve_to_do_lists
        user.to_do_lists.includes(:tasks)
      end
    end
  end
end
