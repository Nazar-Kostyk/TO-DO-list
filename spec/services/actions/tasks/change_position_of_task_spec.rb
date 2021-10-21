# frozen_string_literal: true

RSpec.describe Actions::Tasks::ChangePositionOfTask do
  subject(:result) { described_class.new(user, params).call }

  describe '#call' do
    let!(:user) { create(:user) }
    let!(:to_do_list) { create(:to_do_list_with_tasks, user: user) }
    let!(:task) { to_do_list.tasks.sample }
    let!(:new_position) { to_do_list.tasks.where.not(id: task.id).pluck(:position).sample }

    context 'when params are valid' do
      let(:params) { { to_do_list_id: to_do_list.id, id: task.id, new_position: new_position } }

      it 'returns correct payload' do
        expect(result.payload).to eq(task)
        expect(result.payload[:position]).to eq(new_position)
      end

      context 'when to-do list not found' do
        let(:params) { { to_do_list_id: SecureRandom.uuid, id: task.id, new_position: new_position } }

        it 'raises ActiveRecord::RecordNotFound error' do
          expect { result }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when task not found' do
        let(:params) { { to_do_list_id: to_do_list.id, id: SecureRandom.uuid, new_position: new_position } }

        it 'raises ActiveRecord::RecordNotFound error' do
          expect { result }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when database error occured' do
        before do
          allow_any_instance_of(Task).to receive(:update_position).and_return(nil)
        end

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
