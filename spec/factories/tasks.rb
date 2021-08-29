# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    description { 'MyText' }
    position { 1 }
  end
end
