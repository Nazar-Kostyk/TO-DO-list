# frozen_string_literal: true

# == Schema Information
#
# Table name: admins
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
#  index_admins_on_email  (email) UNIQUE
#
RSpec.describe Admin, type: :model do
  subject(:model) { described_class.new }

  it 'has correct parrent' do
    expect(model).to be_a_kind_of(ApplicationRecord)
  end
end
