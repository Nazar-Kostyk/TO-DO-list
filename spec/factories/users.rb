# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  email      :string           not null
#  name       :string(255)      not null
#  password   :string           not null
#  surname    :string(255)      not null
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
