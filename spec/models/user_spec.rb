# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  name       :string
#  surname    :string
#  email      :string
#  password   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
RSpec.describe User, type: :model do
  it 'has correct parrent' do
    expect(subject).to be_a_kind_of(ApplicationRecord)
  end

  describe 'associations' do
    it { should have_many(:to_do_lists).class_name('ToDoList') }
  end
end
