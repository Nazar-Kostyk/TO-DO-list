# frozen_string_literal: true

RSpec.describe HealthCheckController, :controller do
  it 'has correct parent' do
    expect(controller).to be_a_kind_of(ApplicationController)
  end
end
