# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id            :uuid             not null, primary key
#  is_completed  :boolean          default(FALSE)
#  position      :integer          not null
#  title         :string(255)      default("Untitled")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  to_do_list_id :bigint
#
# Indexes
#
#  index_tasks_on_to_do_list_id  (to_do_list_id)
#
FactoryBot.define do
  factory :task do
    description { 'MyText' }
    position { 1 }
  end
end
