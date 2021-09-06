# frozen_string_literal: true

# == Schema Information
#
# Table name: admins
#
#  id         :uuid             not null, primary key
#  email      :string           not null
#  name       :string(255)      not null
#  password   :string           not null
#  surname    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Admin < ApplicationRecord
end
