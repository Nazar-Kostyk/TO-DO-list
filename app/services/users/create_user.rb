# frozen_string_literal: true

module Users
  class CreateUser < BaseService
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      return validation_errors if validator.failure?

      user = User.new(model_params)

      user.save ? build_success_response(user) : build_database_error_response
    end

    private

    def validator
      @validator ||= ::Users::CreateParamsValidator.new.call(params)
    end

    def validation_errors
      build_validation_errors_response(validator.errors.to_h)
    end

    def model_params
      params.slice(:name, :surname, :email, :password)
    end
  end
end
