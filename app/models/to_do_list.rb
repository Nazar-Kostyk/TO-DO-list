# frozen_string_literal: true

class ToDoList < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
end
