# frozen_string_literal: true

RSpec.describe ToDoListsController, type: :request do
  subject(:controller) { described_class.new }

  let!(:user) { create(:user_with_to_do_lists) }
  let(:authorization_header) { JWTSessions::Session.new(payload: { user_id: user.id }).login[:access] }
  let(:headers) { { 'Authorization' => authorization_header } }

  it 'has correct parent' do
    expect(controller).to be_a_kind_of(ApplicationController)
  end

  describe '#index' do
    let(:endpoint_call) do
      get to_do_lists_path, headers: headers, as: :json
    end

    context 'when params are valid' do
      it 'returns correct response' do
        endpoint_call

        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('to_do_lists/list')
      end
    end
  end

  describe '#create' do
    let(:endpoint_call) do
      post to_do_lists_path, params: params, headers: headers, as: :json
    end

    context 'when params are valid' do
      let(:params) { { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph } }

      it 'creates to-do list' do
        expect { endpoint_call }.to change(ToDoList, :count).by(1)
      end

      it 'returns correct response' do
        endpoint_call

        expect(response).to be_created
        expect(JSON.parse(response.body)).to match_json_schema('to_do_lists/single')
      end
    end

    context 'when params are invalid' do
      before do
        endpoint_call
      end

      let(:params) do
        {
          title: Faker::Lorem.characters(number: ToDoList::TITLE_MAX_LENGTH + 1),
          description: Faker::Lorem.paragraph
        }
      end

      it_behaves_like 'validation errors'
    end
  end

  describe '#show' do
    let(:endpoint_call) do
      get to_do_list_path(to_do_list), headers: headers, as: :json
    end

    context 'when params are valid' do
      let(:to_do_list) { user.to_do_lists.sample }

      it 'returns correct response' do
        endpoint_call

        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('to_do_lists/single')
      end
    end

    context 'when params are invalid' do
      before do
        endpoint_call
      end

      let(:to_do_list) { 'invalid' }

      it_behaves_like 'validation errors'
    end
  end

  describe '#update' do
    let(:endpoint_call) do
      put to_do_list_path(to_do_list), params: params, headers: headers, as: :json
    end
    let(:to_do_list) { user.to_do_lists.sample }

    context 'when params are valid' do
      let(:params) { { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph } }

      it 'returns correct response' do
        endpoint_call

        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('to_do_lists/single')
      end
    end

    context 'when params are invalid' do
      before do
        endpoint_call
      end

      let(:params) do
        {
          title: Faker::Lorem.characters(number: ToDoList::TITLE_MAX_LENGTH + 1),
          description: Faker::Lorem.paragraph
        }
      end

      it_behaves_like 'validation errors'
    end
  end

  describe '#destroy' do
    let(:endpoint_call) do
      delete to_do_list_path(to_do_list), headers: headers, as: :json
    end

    context 'when params are valid' do
      let(:to_do_list) { user.to_do_lists.sample }

      it 'destroys task' do
        expect { endpoint_call }.to change(ToDoList, :count).by(-1)
      end

      it 'returns correct response' do
        endpoint_call

        expect(response).to be_no_content
        expect(response.body).to be_empty
      end
    end

    context 'when params are invalid' do
      before do
        endpoint_call
      end

      let(:to_do_list) { 'invalid' }

      it_behaves_like 'validation errors'
    end
  end
end
