# frozen_string_literal: true

RSpec.shared_examples 'validation errors' do
  it 'returns the bad request' do
    expect(response).to be_bad_request
    expect(JSON.parse(response.body)).to match_json_schema('incorrect_response/validation_errors')
  end
end
