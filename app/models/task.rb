# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id            :uuid             not null, primary key
#  description   :text
#  position      :integer
#  to_do_list_id :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Task < ApplicationRecord
  belongs_to :to_do_list
end
