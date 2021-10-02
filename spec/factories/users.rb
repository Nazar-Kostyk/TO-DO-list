# frozen_string_literal: true

# == Schema Information
#
# Table name: users
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
#  index_users_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    email { Faker::Internet.email }
    password_digest { Faker::Internet.password }

    factory :user_with_to_do_lists do
      transient do
        to_do_lists_count { 3 }
      end

      to_do_lists do
        Array.new(to_do_lists_count) { association(:to_do_list) }
      end
    end
  end
end
