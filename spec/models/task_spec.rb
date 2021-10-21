# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id            :uuid             not null, primary key
#  is_completed  :boolean          default(FALSE)
#  position      :integer          not null
#  title         :string(255)      default("Untitled")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  to_do_list_id :uuid             not null
#
# Indexes
#
#  index_tasks_on_to_do_list_id               (to_do_list_id)
#  index_tasks_on_to_do_list_id_and_position  (to_do_list_id,position) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (to_do_list_id => to_do_lists.id)
#
RSpec.describe Task, type: :model do
  it 'has correct parrent' do
    expect(subject).to be_a_kind_of(ApplicationRecord)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:to_do_list).class_name('ToDoList') }
  end

  describe 'constants' do
    it 'defines TITLE_MAX_LENGTH' do
      expect(described_class.const_defined?(:TITLE_MAX_LENGTH)).to be true
    end
  end

  # # TODO: implement
  # describe '#update_position' do
  # end

  # # TODO: implement
  # describe '#destroy_record' do
  # end
end
