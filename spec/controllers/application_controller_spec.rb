# frozen_string_literal: true

RSpec.describe ApplicationController, :controller do
  it 'has correct parent' do
    expect(controller).to be_a_kind_of(ActionController::API)
  end
end
