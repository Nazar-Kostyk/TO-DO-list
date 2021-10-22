# frozen_string_literal: true

# == Schema Information
#
# Table name: to_do_lists
#
#  id          :uuid             not null, primary key
#  description :text
#  title       :string(180)      default("New Title")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_to_do_lists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
RSpec.describe ToDoList, type: :model do
  it 'has correct parrent' do
    expect(subject).to be_a_kind_of(ApplicationRecord)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).class_name('User') }

    it { is_expected.to have_many(:tasks).class_name('Task') }
  end

  describe 'constants' do
    it 'defines TITLE_MIN_LENGTH' do
      expect(described_class.const_defined?(:TITLE_MIN_LENGTH)).to be true
    end

    it 'defines TITLE_MAX_LENGTH' do
      expect(described_class.const_defined?(:TITLE_MAX_LENGTH)).to be true
    end
  end
end
