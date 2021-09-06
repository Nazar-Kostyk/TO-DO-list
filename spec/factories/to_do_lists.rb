# frozen_string_literal: true

# == Schema Information
#
# Table name: to_do_lists
#
#  id          :uuid             not null, primary key
#  description :text
#  title       :string(255)      default("Untitled")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_to_do_lists_on_user_id  (user_id)
#
FactoryBot.define do
  factory :to_do_list do
    name { 'MyString' }
    description { 'MyText' }
  end
end
