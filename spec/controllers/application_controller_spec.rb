# frozen_string_literal: true

RSpec.describe ApplicationController, :controller do
  it 'has correct parent' do
    expect(controller).to be_a_kind_of(ActionController::API)
  end

  describe '#authorize_request' do
    controller do
      before_action :authorize_access_request!

      def index
        render json: { 'Hello' => 'world' }
      end
    end

    before do
      request.headers['Authorization'] = authorization_header
      get :index
    end

    context 'when Authorization header is valid' do
      let!(:user) { create(:user) }
      let(:authorization_header) { JWTSessions::Session.new(payload: { user_id: user.id }).login[:access] }
      let(:expected_body) { { 'Hello' => 'world' } }

      it 'returns correct response' do
        expect(response).to be_ok
        expect(JSON.parse(response.body)).to eq(expected_body)
      end
    end

    context 'when Authorization header is invalid' do
      let(:authorization_header) { 'invalid' }

      it_behaves_like 'unauthorized request'
    end
  end

  describe '#render_json_response' do
    context 'when a single resource provided' do
      controller do
        def index
          user = User.new(
            name: Faker::Name.first_name,
            surname: Faker::Name.last_name,
            email: Faker::Internet.email,
            password: Faker::Internet.password
          )
          user.save

          render_json_response(data: user, serializer: UserSerializer)
        end
      end

      before { get :index }

      it 'returns correct response' do
        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('users/single')
      end
    end

    xcontext 'when a list of resources provided' do
      controller do
        def index
          users = Array.new(3) do
            User.new(
              name: Faker::Name.first_name,
              surname: Faker::Name.last_name,
              email: Faker::Internet.email,
              password: Faker::Internet.password
            )
          end
          users.map(&:save)

          render_json_response(data: users, serializer: UserSerializer, options: { collection: true })
        end
      end

      before { get :index }

      it 'returns correct response' do
        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('users/list')
      end
    end
  end

  describe '#not_found' do
    controller do
      def index
        User.find(SecureRandom.uuid)
      end
    end

    before { get :index }

    it_behaves_like 'entity not found', User
  end

  describe '#render_json_error' do
    controller do
      def index
        render_json_error(status: :not_found, error_key: 'user_not_found')
      end
    end

    before { get :index }

    it_behaves_like 'entity not found', User
  end

  describe '#render_json_validation_error' do
    controller do
      def index
        render_json_validation_error({ id: ['Not found.'] })
      end
    end

    before { get :index }

    let(:expected_body) do
      {
        'errors' => [
          {
            'source' => {
              'pointer' => '/data/attributes/id'
            },
            'detail' => 'Not found.'
          }
        ]
      }
    end

    it 'returns the bad request' do
      expect(response).to be_bad_request
      expect(JSON.parse(response.body)).to eq(expected_body)
    end
  end
end
