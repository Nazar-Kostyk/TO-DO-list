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
FactoryBot.define do
  factory :user do
    name { 'MyString' }
    surname { 'MyString' }
    email { 'MyString' }
    password { 'MyString' }
  end
end
