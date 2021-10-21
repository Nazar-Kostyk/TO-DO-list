# frozen_string_literal: true

RSpec.describe Actions::ToDoLists::UpdateToDoList do
  subject(:result) { described_class.new(user, params).call }

  describe '#call' do
    let!(:user) { create(:user_with_to_do_lists) }
    let!(:to_do_list_id) { user.to_do_lists.sample.id }

    context 'when params are valid' do
      let(:params) { { id: to_do_list_id }.merge(attributes_for(:to_do_list)) }

      it 'returns correct payload' do
        expect(result.payload).to eq(ToDoList.find(to_do_list_id))
        expect(result.payload[:title]).to eq(params[:title])
        expect(result.payload[:description]).to eq(params[:description])
      end

      context 'when to-do list not found' do
        let(:params) { { id: SecureRandom.uuid }.merge(attributes_for(:to_do_list)) }

        it 'raises ActiveRecord::RecordNotFound error' do
          expect { result }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when database error occured' do
        before do
          allow_any_instance_of(ToDoList).to receive(:update).and_return(nil)
        end

        let(:params) { { id: to_do_list_id }.merge(attributes_for(:to_do_list)) }

        it_behaves_like 'database error'
      end
    end

    context 'when params are invalid' do
      let(:params) { {} }

      it 'sets error' do
        expect(result.error).to be_present
      end
    end
  end
end
