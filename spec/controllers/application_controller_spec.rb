# frozen_string_literal: true

RSpec.describe ApplicationController, :controller do
  it 'has correct parent' do
    expect(controller).to be_a_kind_of(ActionController::API)
  end

  describe '#authorize_request' do
    controller do
      before_action :authorize_request

      def index
        render json: { 'Hello' => 'world' }, status: :ok
      end
    end

    before do
      request.headers['Authorization'] = authorization_header
      get :index
    end

    context 'when Authorization header is valid' do
      context 'when user is found' do
        let!(:user) { create(:user) }
        let(:authorization_header) { JsonWebToken.encode(user_id: user.id) }
        let(:expected_body) { { 'Hello' => 'world' } }

        it 'returns correct response' do
          expect(response).to be_ok
          expect(JSON.parse(response.body)).to eq(expected_body)
        end
      end

      context 'when user is not found' do
        let(:authorization_header) { JsonWebToken.encode(user_id: SecureRandom.uuid) }
        let(:expected_body) do
          {
            'errors' => [
              {
                'code' => 404,
                'title' => I18n.t('error_messages.user_not_found.title'),
                'detail' => I18n.t('error_messages.user_not_found.detail')
              }
            ]
          }
        end

        it 'returns not_found' do
          expect(response).to be_not_found
          expect(JSON.parse(response.body)).to eq(expected_body)
        end
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

      it 'returns unauthorized' do
        expect(response).to be_unauthorized
        expect(JSON.parse(response.body)).to eq(expected_body)
      end
    end
  end
end
