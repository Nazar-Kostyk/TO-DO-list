# frozen_string_literal: true

# == Schema Information
#
# Table name: to_do_lists
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :text
#  user_id     :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :to_do_list do
    name { 'MyString' }
    description { 'MyText' }
  end
end
