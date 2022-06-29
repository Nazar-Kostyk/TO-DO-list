# frozen_string_literal: true

RSpec.describe HealthCheckController, type: :request do
  subject(:controller) { described_class.new }

  it 'has correct parent' do
    expect(controller).to be_a_kind_of(ApplicationController)
  end

  describe '#health' do
    before { get root_path }

    let(:expected_body) { { 'Hello' => 'world' } }

    it 'return correct response' do
      expect(response).to be_ok
      expect(JSON.parse(response.body)).to eq(expected_body)
    end
  end
end
