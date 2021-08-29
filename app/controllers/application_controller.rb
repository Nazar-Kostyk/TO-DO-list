# frozen_string_literal: true

class ApplicationController < ActionController::API
  def index
    render json: { 'Hello' => 'world' }
  end
end
