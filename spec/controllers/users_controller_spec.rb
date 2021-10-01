# frozen_string_literal: true

RSpec.describe UsersController, type: :request do
  it 'has correct parent' do
    expect(subject).to be_a_kind_of(ApplicationController)
  end

  describe '#show' do
    let(:endpoint_call) do
      headers = { 'Authorization' => authorization_header }
      get user_path, headers: headers
    end

    let!(:user) { create(:user) }

    context 'when Authorization header is valid' do
      let(:authorization_header) { JsonWebToken.encode(user_id: user.id) }

      it 'returns correct response' do
        endpoint_call

        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('users/single')
      end
    end

    context 'when Authorization header is invalid' do
      before do
        endpoint_call
      end

      let(:authorization_header) { 'invalid' }

      it_behaves_like 'unauthorized request'
    end
  end

  describe '#create' do
    let(:endpoint_call) do
      post user_path, params: params
    end

    context 'when valid params provided' do
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

      context 'when database error occured' do
        before do
          allow_any_instance_of(User).to receive(:save).and_return(nil)
          endpoint_call
        end

        it_behaves_like 'database error'
      end
    end

    context 'when invalid params provided' do
      context 'when required params are missing' do
        let(:params) { {} }
        let(:expected_body) do
          {
            'errors' =>
              %i[name surname email password password_confirmation].map do |attribute|
                {
                  'source' => {
                    'pointer' => "/data/attributes/#{attribute}"
                  },
                  'detail' => I18n.t('dry_validation.errors.key?')
                }
              end
          }
        end

        it 'returns the bad request' do
          endpoint_call

          expect(response).to be_bad_request
          expect(JSON.parse(response.body)).to eq(expected_body)
        end
      end
    end
  end

  describe '#update' do
    let(:endpoint_call) do
      headers = { 'Authorization' => authorization_header }
      put user_path, params: params, headers: headers
    end

    let(:password) { Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH) }
    let!(:user) { create(:user, password: password) }

    context 'when Authorization header is valid' do
      let(:authorization_header) { JsonWebToken.encode(user_id: user.id) }

      context 'when valid params provided' do
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

        context 'when database error occured' do
          before do
            allow_any_instance_of(User).to receive(:update).and_return(nil)
            endpoint_call
          end

          it_behaves_like 'database error'
        end
      end

      context 'when invalid params provided' do
        context 'when required field is missing' do
          let(:params) { {} }
          let(:expected_body) do
            {
              'errors' => [
                {
                  'source' => {
                    'pointer' => '/data/attributes/current_password'
                  },
                  'detail' => I18n.t('dry_validation.errors.key?')
                }
              ]
            }
          end

          it 'returns the bad request' do
            endpoint_call

            expect(response).to be_bad_request
            expect(JSON.parse(response.body)).to eq(expected_body)
          end
        end

        context 'when current_password is invalid' do
          let(:params) { { current_password: Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH) } }
          let(:expected_body) do
            {
              'errors' => [
                {
                  'code' => 401,
                  'title' => I18n.t('error_messages.wrong_password.title'),
                  'detail' => I18n.t('error_messages.wrong_password.detail')
                }
              ]
            }
          end

          it 'returns the bad request' do
            endpoint_call

            expect(response).to be_unauthorized
            expect(JSON.parse(response.body)).to eq(expected_body)
          end
        end
      end
    end

    context 'when Authorization header is invalid' do
      before do
        endpoint_call
      end

      let(:authorization_header) { 'invalid' }
      let(:params) { {} }

      it_behaves_like 'unauthorized request'
    end
  end
end
