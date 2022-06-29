# frozen_string_literal: true

RSpec.describe ToDoLists::GetListOfToDoLists do
  subject(:result) { described_class.new(user).call }

  describe '#call' do
    let!(:user) { create(:user_with_to_do_lists) }

    it 'returns correct payload' do
      expect(result.payload).to eq(user.to_do_lists.includes(:tasks))
    end
  end
end
