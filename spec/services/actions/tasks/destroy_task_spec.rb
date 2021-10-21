# frozen_string_literal: true

RSpec.describe Actions::Tasks::DestroyTask do
  subject(:result) { described_class.new(user, params).call }

  describe '#call' do
    let!(:user) { create(:user) }
    let!(:to_do_list) { create(:to_do_list_with_tasks, user: user) }
    let!(:task) { to_do_list.tasks.sample }

    context 'when params are valid' do
      let(:params) { { to_do_list_id: to_do_list.id, id: task.id } }

      it 'destroys task' do
        expect { result }.to change(Task, :count).by(-1)
      end

      it 'returns correct payload' do
        expect(result.payload).to eq(I18n.t('notifications.resource_destroyed'))
      end

      context 'when to-do list not found' do
        let(:params) { { to_do_list_id: SecureRandom.uuid, id: task.id, title: Faker::Tea.variety } }

        it 'raises ActiveRecord::RecordNotFound error' do
          expect { result }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when task not found' do
        let(:params) { { to_do_list_id: to_do_list.id, id: SecureRandom.uuid, title: Faker::Tea.variety } }

        it 'raises ActiveRecord::RecordNotFound error' do
          expect { result }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when database error occured' do
        before do
          allow_any_instance_of(Task).to receive(:destroy_record).and_return(nil)
        end

        let(:params) { { to_do_list_id: to_do_list.id, id: task.id } }

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
