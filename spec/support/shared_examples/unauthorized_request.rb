# frozen_string_literal: true

RSpec.shared_examples 'unauthorized request' do
  let(:expected_body) do
    {
      'errors' => [
        {
          'code' => 401,
          'title' => I18n.t('error_messages.unauthorized_request.title'),
          'detail' => I18n.t('error_messages.unauthorized_request.detail')
        }
      ]
    }
  end

  it 'returns the unauthorized request' do
    expect(response).to be_unauthorized
    expect(JSON.parse(response.body)).to eq(expected_body)
  end
end
