# frozen_string_literal: true

RSpec.describe ApplicationController, :controller do
  it 'has correct parent' do
    expect(controller).to be_a_kind_of(ActionController::API)
  end

  describe 'GET #index' do
    before do
      get :index
    end

    let(:expected_body) { { 'Hello' => 'world' } }

    it 'return correct response' do
      expect(response).to be_ok
      expect(JSON.parse(response.body)).to eq(expected_body)
    end
  end
end
