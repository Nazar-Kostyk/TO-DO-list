# frozen_string_literal: true

# HealthCheckController: allows user to check the service health status
class HealthCheckController < ApplicationController
  def health
    render json: { 'Hello' => 'world' }
  end
end
