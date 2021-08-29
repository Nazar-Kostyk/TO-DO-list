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
FactoryBot.define do
  factory :admin do
  end
end
