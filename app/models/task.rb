# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id            :uuid             not null, primary key
#  is_completed  :boolean          default(FALSE)
#  position      :integer          not null
#  title         :string(255)      default("Untitled")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  to_do_list_id :uuid             not null
#
# Indexes
#
#  index_tasks_on_to_do_list_id               (to_do_list_id)
#  index_tasks_on_to_do_list_id_and_position  (to_do_list_id,position) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (to_do_list_id => to_do_lists.id)
#
class Task < ApplicationRecord
  TITLE_MAX_LENGTH = 255

  belongs_to :to_do_list

  def update_position(new_position)
    return self if position == new_position

    Task.transaction do
      # Do not check the position uniqueness constraint until the transaction commit
      ActiveRecord::Base.connection.execute('SET CONSTRAINTS index_tasks_on_to_do_list_id_and_position DEFERRED')

      if position < new_position
        Task.where('to_do_list_id = ? AND position > ? AND position <= ?', to_do_list_id, position, new_position)
            .update_all('position = position - 1')
      else
        Task.where('to_do_list_id = ? AND position >= ? AND position < ?', to_do_list_id, new_position, position)
            .update_all('position = position + 1')
      end

      update!(position: new_position)
    end
  end

  def destroy_record
    Task.transaction do
      # Do not check the position uniqueness constraint until the transaction commit
      ActiveRecord::Base.connection.execute('SET CONSTRAINTS index_tasks_on_to_do_list_id_and_position DEFERRED')

      destroy!
      Task.where('to_do_list_id = ? AND position > ?', to_do_list_id, position).update_all('position = position - 1')
    end
  end
end
