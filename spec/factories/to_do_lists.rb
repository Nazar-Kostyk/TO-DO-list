# frozen_string_literal: true

# == Schema Information
#
# Table name: to_do_lists
#
#  id          :uuid             not null, primary key
#  description :text
#  title       :string(180)      default("New Title")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_to_do_lists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :to_do_list do
    user
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }

    factory :to_do_list_with_tasks do
      transient { tasks_count { 3 } }

      tasks { Array.new(tasks_count) { association(:task) } }
    end
  end
end
