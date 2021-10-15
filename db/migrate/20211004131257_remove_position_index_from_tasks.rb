# frozen_string_literal: true

class RemovePositionIndexFromTasks < ActiveRecord::Migration[6.1]
  def up
    remove_index :tasks, :position
  end

  def down
    add_index :tasks, :position, unique: true
  end
end
