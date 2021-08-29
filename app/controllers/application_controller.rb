# frozen_string_literal: true

# ApplicationController: base controller
class ApplicationController < ActionController::API
  # Default action
  def index
    render json: { 'Hello' => 'world' }
  end
end
