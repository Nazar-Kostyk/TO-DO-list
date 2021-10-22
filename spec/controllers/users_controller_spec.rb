# frozen_string_literal: true

RSpec.describe UsersController, type: :request do
  subject(:controller) { described_class.new }

  it 'has correct parent' do
    expect(controller).to be_a_kind_of(ApplicationController)
  end

  describe '#show' do
    let!(:user) { create(:user) }
    let(:authorization_header) { JWTSessions::Session.new(payload: { user_id: user.id }).login[:access] }
    let(:headers) { { 'Authorization' => authorization_header } }

    let(:endpoint_call) do
      get user_path, headers: headers, as: :json
    end

    context 'when params are valid' do
      it 'returns correct response' do
        endpoint_call

        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('users/single')
      end
    end
  end

  describe '#create' do
    let(:endpoint_call) do
      post user_path, params: params
    end

    context 'when params are valid' do
      let(:password) { Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH) }
      let(:params) do
        {
          name: Faker::Name.first_name,
          surname: Faker::Name.last_name,
          email: Faker::Internet.email,
          password: password,
          password_confirmation: password
        }
      end

      it 'creates user' do
        expect { endpoint_call }.to change(User, :count).by(1)
      end

      it 'returns correct response' do
        endpoint_call

        expect(response).to be_created
        expect(JSON.parse(response.body)).to match_json_schema('users/single')
      end
    end

    context 'when params are invalid' do
      before do
        endpoint_call
      end

      let(:params) { {} }

      it_behaves_like 'validation errors'
    end
  end

  describe '#update' do
    let(:password) { Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH) }
    let!(:user) { create(:user, password: password) }
    let(:authorization_header) { JWTSessions::Session.new(payload: { user_id: user.id }).login[:access] }
    let(:headers) { { 'Authorization' => authorization_header } }

    let(:endpoint_call) do
      put user_path, params: params, headers: headers, as: :json
    end

    context 'when params are valid' do
      let(:new_password) { Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH) }
      let(:params) do
        {
          name: Faker::Name.first_name,
          surname: Faker::Name.last_name,
          email: Faker::Internet.email,
          current_password: password,
          new_password: new_password,
          new_password_confirmation: new_password
        }
      end

      it 'returns correct response' do
        endpoint_call

        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('users/single')
      end
    end

    context 'when params are invalid' do
      before do
        endpoint_call
      end

      let(:params) { {} }

      it_behaves_like 'validation errors'
    end
  end
end
