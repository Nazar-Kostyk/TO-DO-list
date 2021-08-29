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
require 'rails_helper'

RSpec.describe ToDoList, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
