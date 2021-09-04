# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id            :uuid             not null, primary key
#  description   :text
#  position      :integer
#  to_do_list_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
RSpec.describe Task, type: :model do
  it 'has correct parrent' do
    expect(subject).to be_a_kind_of(ApplicationRecord)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:to_do_list).class_name('ToDoList') }
  end
end
