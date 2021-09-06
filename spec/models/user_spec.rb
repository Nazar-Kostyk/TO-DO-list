# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string           not null
#  name            :string(255)      not null
#  password_digest :string           not null
#  surname         :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
RSpec.describe User, type: :model do
  it 'has correct parrent' do
    expect(subject).to be_a_kind_of(ApplicationRecord)
  end

  describe 'associations' do
    it { is_expected.to have_many(:to_do_lists).class_name('ToDoList') }
  end
end
