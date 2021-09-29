# frozen_string_literal: true

RSpec.describe ToDoListsController, type: :request do
  it 'has correct parent' do
    expect(subject).to be_a_kind_of(ApplicationController)
  end

  describe '#index' do
    let(:endpoint_call) do
      headers = { 'Authorization' => authorization_header }
      get to_do_lists_path, headers: headers
    end

    context 'when Authorization header is valid' do
      let!(:user) { create(:user_with_to_do_lists) }
      let(:authorization_header) { JsonWebToken.encode(user_id: user.id) }

      it 'returns correct response' do
        endpoint_call

        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('users/single')
      end
    end

    context 'when Authorization header is invalid' do
      let(:authorization_header) { Faker::Lorem.characters(number: 128) }
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
        endpoint_call

        expect(response).to be_unauthorized
        expect(JSON.parse(response.body)).to eq(expected_body)
      end
    end
  end
end
