# frozen_string_literal: true

RSpec.describe TasksController, type: :request do
  let!(:user) { create(:user) }
  let(:authorization_header) { JWTSessions::Session.new(payload: { user_id: user.id }).login[:access] }
  let(:headers) { { 'Authorization' => authorization_header } }

  it 'has correct parent' do
    expect(subject).to be_a_kind_of(ApplicationController)
  end

  describe '#index' do
    let!(:to_do_list) { create(:to_do_list_with_tasks, user: user) }

    context 'when params are valid' do
      let(:endpoint_call) do
        get to_do_list_tasks_path(to_do_list), headers: headers
      end

      it 'return correct response' do
        endpoint_call

        expect(response).to be_ok
        expect(JSON.parse(response.body)).to match_json_schema('tasks/list')
      end
    end

    context 'when valid params are invalid' do
      let(:endpoint_call) do
        get to_do_list_tasks_path('invalid'), headers: headers
      end

      it 'return correct response' do
        endpoint_call

        expect(response).to be_bad_request
        expect(JSON.parse(response.body)).to match_json_schema('incorrect_response/validation_errors')
      end
    end
  end
end
