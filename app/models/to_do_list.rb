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
class ToDoList < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
end
