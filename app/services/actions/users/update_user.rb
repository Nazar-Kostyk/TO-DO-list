# frozen_string_literal: true

module Actions
  module Users
    class UpdateUser < BaseActionService
      attr_reader :user, :params

      def initialize(user, params)
        @user = user
        @params = params
      end

      def call
        return validation_errors if validator.failure?
        return wrong_password_entered unless correct_password_provdided?

        user.update(map_request_params_to_model_params) ? build_success_response(user) : build_database_error
      end

      private

      def validator
        @validator ||= ::Users::UpdateParamsValidator.new.call(params)
      end

      def validation_errors
        build_validation_errors(validator.errors.to_h)
      end

      def correct_password_provdided?
        user.authenticate(params[:current_password])
      end

      def wrong_password_entered
        build_failure_response(
          {
            status: :unauthorized,
            details: error_details_by_translation_key('wrong_password')
          }
        )
      end

      def map_request_params_to_model_params
        params.slice(:name, :surname, :email)
              .merge({ password: params[:new_password] })
              .compact
      end
    end
  end
end
