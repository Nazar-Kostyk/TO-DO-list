# frozen_string_literal: true

class User < ApplicationRecord
  has_many :to_do_lists, dependent: :destroy
end
