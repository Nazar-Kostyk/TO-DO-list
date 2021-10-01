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

    let!(:user) { create(:user_with_to_do_lists) }

    context 'when Authorization header is valid' do
      let(:authorization_header) { JsonWebToken.encode(user_id: user.id) }

      it 'returns correct response' do
        endpoint_call

        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('to_do_lists/list')
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

  describe '#show' do
    let(:endpoint_call) do
      headers = { 'Authorization' => authorization_header }
      get to_do_list_path(to_do_list_id), headers: headers
    end

    let!(:user) { create(:user_with_to_do_lists) }
    let(:to_do_list_id) { user.to_do_lists.sample.id }

    context 'when Authorization header is valid' do
      let(:authorization_header) { JsonWebToken.encode(user_id: user.id) }

      context 'when params are valid' do
        it 'returns correct response' do
          endpoint_call

          expect(response).to be_ok
          expect(JSON.parse(response.body)).to match_json_schema('to_do_lists/single')
          expect(JSON.parse(response.body)['data']['id']).to eq(to_do_list_id)
        end

        context 'when to-do list not found' do
          let(:to_do_list_id) { SecureRandom.uuid }
          let(:expected_body) do
            {
              'errors' => [
                {
                  'code' => 404,
                  'title' => I18n.t('error_messages.to_do_list_not_found.title'),
                  'detail' => I18n.t('error_messages.to_do_list_not_found.detail')
                }
              ]
            }
          end

          it 'returns not_found' do
            endpoint_call

            expect(response).to be_not_found
            expect(JSON.parse(response.body)).to eq(expected_body)
          end
        end
      end

      context 'when params are invalid' do
        let(:to_do_list_id) { 'invalid' }
        let(:expected_body) do
          {
            'errors' => [
              {
                'source' => {
                  'pointer' => '/data/attributes/id'
                },
                'detail' => I18n.t('dry_validation.errors.invalid_format', field: 'id', format_name: :UUID)
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
      headers = { 'Authorization' => authorization_header }
      post to_do_lists_path, params: params, headers: headers
    end

    let!(:user) { create(:user) }

    context 'when Authorization header is valid' do
      let(:authorization_header) { JsonWebToken.encode(user_id: user.id) }

      context 'when params are valid' do
        let(:params) { { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph } }

        it 'creates to-do list' do
          expect { endpoint_call }.to change(ToDoList, :count).by(1)
          expect(user.to_do_lists.size).to eq(1)
        end

        it 'returns correct response' do
          endpoint_call

          expect(response).to be_created
          expect(JSON.parse(response.body)).to match_json_schema('to_do_lists/single')
        end

        context 'when database error occured' do
          before do
            allow_any_instance_of(ToDoList).to receive(:save).and_return(nil)
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

      context 'when params are invalid' do
        let(:params) do
          {
            title: Faker::Lorem.characters(number: ToDoList::TITLE_MAX_LENGTH + 1),
            description: Faker::Lorem.paragraph
          }
        end
        let(:expected_body) do
          {
            'errors' => [
              {
                'source' => {
                  'pointer' => '/data/attributes/title'
                },
                'detail' =>
                  I18n.t(
                    'dry_validation.errors.exceeds_maximum_length',
                    field: :title,
                    length: ToDoList::TITLE_MAX_LENGTH
                  )
              }
            ]
          }
        end

        it 'returns correct response' do
          endpoint_call

          expect(response).to be_bad_request
          expect(JSON.parse(response.body)).to eq(expected_body)
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

  describe '#update' do
    let(:endpoint_call) do
      headers = { 'Authorization' => authorization_header }
      put to_do_list_path(to_do_list_id), params: params, headers: headers
    end

    let!(:user) { create(:user_with_to_do_lists) }
    let(:to_do_list_id) { user.to_do_lists.sample.id }

    context 'when Authorization header is valid' do
      let(:authorization_header) { JsonWebToken.encode(user_id: user.id) }

      context 'when params are valid' do
        let(:params) { { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph } }

        it 'returns correct response' do
          endpoint_call

          expect(response).to be_ok
          expect(JSON.parse(response.body)).to match_json_schema('to_do_lists/single')
        end

        context 'when database error occured' do
          before do
            allow_any_instance_of(ToDoList).to receive(:update).and_return(nil)
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

      context 'when params are invalid' do
        let(:to_do_list_id) { 'invalid' }
        let(:params) do
          {
            title: Faker::Lorem.characters(number: ToDoList::TITLE_MAX_LENGTH + 1),
            description: Faker::Lorem.paragraph
          }
        end
        let(:expected_body) do
          {
            'errors' => [
              {
                'source' => {
                  'pointer' => '/data/attributes/id'
                },
                'detail' => I18n.t('dry_validation.errors.invalid_format', field: 'id', format_name: :UUID)
              },
              {
                'source' => {
                  'pointer' => '/data/attributes/title'
                },
                'detail' =>
                  I18n.t(
                    'dry_validation.errors.exceeds_maximum_length',
                    field: :title,
                    length: ToDoList::TITLE_MAX_LENGTH
                  )
              }
            ]
          }
        end

        it 'returns correct response' do
          endpoint_call

          expect(response).to be_bad_request
          expect(JSON.parse(response.body)).to eq(expected_body)
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

  describe '#destroy' do
    let(:endpoint_call) do
      headers = { 'Authorization' => authorization_header }
      delete to_do_list_path(to_do_list_id), headers: headers
    end

    let!(:user) { create(:user_with_to_do_lists) }
    let(:to_do_list_id) { user.to_do_lists.sample.id }

    context 'when Authorization header is valid' do
      let(:authorization_header) { JsonWebToken.encode(user_id: user.id) }

      context 'when params are valid' do
        it 'deletes to-do list' do
          expect { endpoint_call }.to change(ToDoList, :count).by(-1)
        end

        it 'returns correct response' do
          endpoint_call

          expect(response).to be_no_content
          expect(response.body).to be_empty
        end

        context 'when to-do list not found' do
          let(:to_do_list_id) { SecureRandom.uuid }
          let(:expected_body) do
            {
              'errors' => [
                {
                  'code' => 404,
                  'title' => I18n.t('error_messages.to_do_list_not_found.title'),
                  'detail' => I18n.t('error_messages.to_do_list_not_found.detail')
                }
              ]
            }
          end

          it 'returns not_found' do
            endpoint_call

            expect(response).to be_not_found
            expect(JSON.parse(response.body)).to eq(expected_body)
          end
        end

        context 'when database error occured' do
          before do
            allow_any_instance_of(ToDoList).to receive(:destroy).and_return(nil)
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

      context 'when params are invalid' do
        let(:to_do_list_id) { 'invalid' }
        let(:expected_body) do
          {
            'errors' => [
              {
                'source' => {
                  'pointer' => '/data/attributes/id'
                },
                'detail' => I18n.t('dry_validation.errors.invalid_format', field: 'id', format_name: :UUID)
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
    end

    context 'when Authorization header is invalid' do
      before do
        endpoint_call
      end

      let(:authorization_header) { 'invalid' }

      it_behaves_like 'unauthorized request'
    end
  end
end
