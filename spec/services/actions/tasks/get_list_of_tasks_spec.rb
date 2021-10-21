# frozen_string_literal: true

RSpec.describe Actions::Tasks::GetListOfTasks do
  subject(:result) { described_class.new(user, params).call }

  describe '#call' do
    let!(:user) { create(:user) }
    let!(:to_do_list) { create(:to_do_list_with_tasks, user: user) }

    context 'when params are valid' do
      let(:params) { { to_do_list_id: to_do_list.id } }

      it 'returns correct payload' do
        expect(result.payload).to eq(to_do_list.tasks)
      end

      context 'when to-do list not found' do
        let(:params) { { to_do_list_id: SecureRandom.uuid } }

        it 'raises ActiveRecord::RecordNotFound error' do
          expect { result }.to raise_error(ActiveRecord::RecordNotFound)
        end
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
