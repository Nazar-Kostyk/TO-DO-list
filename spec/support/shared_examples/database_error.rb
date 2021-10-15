# frozen_string_literal: true

RSpec.shared_examples 'database error' do
  let(:expected_body) do
    {
      'errors' => [
        {
          'title' => I18n.t('error_messages.database_error.title'),
          'detail' => I18n.t('error_messages.database_error.detail')
        }
      ]
    }
  end

  it 'returns the bad request' do
    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)).to eq(expected_body)
  end
end
