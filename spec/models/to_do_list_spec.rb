# frozen_string_literal: true

# == Schema Information
#
# Table name: to_do_lists
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :text
#  user_id     :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
RSpec.describe ToDoList, type: :model do
  it 'has correct parrent' do
    expect(subject).to be_a_kind_of(ApplicationRecord)
  end

  describe 'associations' do
    it { should belong_to(:user).class_name('User') }

    it { should have_many(:tasks).class_name('Task') }
  end
end
