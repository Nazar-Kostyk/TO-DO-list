# frozen_string_literal: true

RSpec.describe Actions::ToDoLists::DestroyToDoList do
  subject(:result) { described_class.new(user, params).call }

  describe '#call' do
    let!(:user) { create(:user_with_to_do_lists) }
    let!(:to_do_list_id) { user.to_do_lists.sample.id }

    context 'when params are valid' do
      let(:params) { { id: to_do_list_id } }

      it 'destroys task' do
        expect { result }.to change(ToDoList, :count).by(-1)
      end

      it 'returns correct payload' do
        expect(result.payload).to eq(I18n.t('notifications.resource_destroyed'))
      end

      context 'when to-do list not found' do
        let(:params) { { id: SecureRandom.uuid } }

        it 'raises ActiveRecord::RecordNotFound error' do
          expect { result }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when database error occured' do
        before do
          allow_any_instance_of(ToDoList).to receive(:destroy).and_return(nil)
        end

        let(:params) { { id: to_do_list_id } }

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
