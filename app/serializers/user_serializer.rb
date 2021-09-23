# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  attributes :name, :surname, :email
  # has_many :to_do_lists
end
