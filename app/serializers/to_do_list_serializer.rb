# frozen_string_literal: true

class ToDoListSerializer
  include JSONAPI::Serializer

  attributes :title, :description
  # has_many :tasks
end
