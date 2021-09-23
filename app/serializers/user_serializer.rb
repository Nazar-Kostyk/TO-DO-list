# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  attributes :name, :surname, :email, :created_at, :updated_at
  # has_many :to_do_lists
end
