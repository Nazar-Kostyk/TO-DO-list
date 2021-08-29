# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id            :uuid             not null, primary key
#  description   :text
#  position      :integer
#  to_do_list_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :task do
    description { 'MyText' }
    position { 1 }
  end
end
