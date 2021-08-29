# frozen_string_literal: true

# == Schema Information
#
# Table name: admins
#
#  id         :uuid             not null, primary key
#  name       :string
#  surname    :string
#  email      :string
#  password   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
RSpec.describe Admin, type: :model do
  it 'has correct parrent' do
    expect(subject).to be_a_kind_of(ApplicationRecord)
  end
end
