# frozen_string_literal: true

RSpec.describe UsersController, :controller do
  it 'has correct parent' do
    expect(controller).to be_a_kind_of(ApplicationController)
  end

  describe '#create' do
    let(:endpoint_call) do
      post :create, params: params
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

      it 'returns correct response' do
        endpoint_call

        expect(response).to be_created
        expect(JSON.parse(response.body)).to match_json_schema('users/single')
      end

      it 'creates user' do
        expect { endpoint_call }.to change(User, :count).by(1)
      end

      context 'when database error occured' do
        before do
          allow_any_instance_of(User).to receive(:save).and_return(nil)
        end

        let(:expected_body) do
          {
            'errors' => [
              {
                'code' => 422,
                'title' => I18n.t('error_messages.database_error.title'),
                'detail' => I18n.t('error_messages.database_error.detail')
              }
            ]
          }
        end

        it 'returns the bad request' do
          endpoint_call

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq(expected_body)
        end
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
      request.headers['Authorization'] = authorization_header
      put :update, params: params
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
            allow_any_instance_of(User).to receive(:update).with(expected_params).and_return(nil)
          end

          let(:expected_params) do
            params.slice(:name, :surname, :email).merge({ password: params[:new_password] }).with_indifferent_access
          end
          let(:expected_body) do
            {
              'errors' => [
                {
                  'code' => 422,
                  'title' => I18n.t('error_messages.database_error.title'),
                  'detail' => I18n.t('error_messages.database_error.detail')
                }
              ]
            }
          end

          it 'returns the bad request' do
            endpoint_call

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq(expected_body)
          end
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
      let(:authorization_header) { Faker::Lorem.characters(number: 128) }
      let(:params) { {} }
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
