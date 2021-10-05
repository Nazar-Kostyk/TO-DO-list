# frozen_string_literal: true

# ApplicationController: base controller
class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def current_user
    @current_user ||= User.find(payload['user_id'])
  end

  def render_json_response(data:, serializer:, options: {}, status: :ok)
    render json: serializer.new(data, options).serializable_hash, status: status
  end

  def not_found(exception)
    render_json_error(status: :not_found, error_key: "#{exception.model.underscore}_not_found")
  end

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end

  def render_json_error(status:, error_key:)
    code = status.is_a?(Symbol) ? Rack::Utils::SYMBOL_TO_STATUS_CODE[status] : 500

    error = {
      code: code,
      title: I18n.t("error_messages.#{error_key}.title", default: ''),
      detail: I18n.t("error_messages.#{error_key}.detail", default: '')
    }.compact_blank

    render json: { errors: [error] }, status: status
  end

  def render_json_validation_error(errors_hash)
    errors =
      errors_hash.map do |attribute_name, error_details|
        error_details.map do |detail|
          {
            source: {
              pointer: "/data/attributes/#{attribute_name}"
            },
            detail: detail
          }
        end
      end.flatten

    render json: { errors: errors }, status: :bad_request
  end
end
