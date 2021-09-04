# frozen_string_literal: true

# HealthCheckController: allows user to check the service health status
class HealthCheckController < ApplicationController
  # Returns service health status
  def health
    render json: { 'Hello' => 'world' }
  end
end
