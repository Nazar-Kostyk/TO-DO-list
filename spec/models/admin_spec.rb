# frozen_string_literal: true

# == Schema Information
#
# Table name: admins
#
#  id         :uuid             not null, primary key
#  name       :string
#  surname    :string
#  email      :string
#  password   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Admin, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
