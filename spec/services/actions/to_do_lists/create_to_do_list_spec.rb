# frozen_string_literal: true

RSpec.describe Actions::ToDoLists::CreateToDoList do
  subject(:result) { described_class.new(user, params).call }

  describe '#call' do
    let(:user) { create(:user) }

    context 'when params are valid' do
      let(:params) { attributes_for(:to_do_list) }

      it 'creates to-do list' do
        expect { result }.to change(ToDoList, :count).by(1)
      end

      it 'returns correct payload' do
        expect(result.payload).to eq(ToDoList.last)
      end

      context 'when database error occured' do
        before do
          allow_any_instance_of(ToDoList).to receive(:save).and_return(nil)
        end

        let(:params) { attributes_for(:to_do_list) }

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
