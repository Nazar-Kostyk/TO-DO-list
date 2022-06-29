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
  subject(:model) { described_class.new }

  it 'has correct parrent' do
    expect(model).to be_a_kind_of(ApplicationRecord)
  end

  describe 'associations' do
    it { is_expected.to have_many(:to_do_lists).class_name('ToDoList') }
  end

  describe 'constants' do
    it 'defines NAME_MAX_LENGTH' do
      expect(described_class.const_defined?(:NAME_MAX_LENGTH)).to be true
    end

    it 'defines SURNAME_MAX_LENGTH' do
      expect(described_class.const_defined?(:SURNAME_MAX_LENGTH)).to be true
    end

    it 'defines EMAIL_MIN_LENGTH' do
      expect(described_class.const_defined?(:EMAIL_MIN_LENGTH)).to be true
    end

    it 'defines EMAIL_MAX_LENGTH' do
      expect(described_class.const_defined?(:EMAIL_MAX_LENGTH)).to be true
    end

    it 'defines PASSWORD_MIN_LENGTH' do
      expect(described_class.const_defined?(:PASSWORD_MIN_LENGTH)).to be true
    end

    it 'defines PASSWORD_MAX_LENGTH' do
      expect(described_class.const_defined?(:PASSWORD_MAX_LENGTH)).to be true
    end
  end
end
