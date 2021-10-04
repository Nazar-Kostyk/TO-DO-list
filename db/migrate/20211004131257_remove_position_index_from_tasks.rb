# frozen_string_literal: true

class RemovePositionIndexFromTasks < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        remove_index :tasks, :position
      end

      dir.down do
        add_index :tasks, :position, unique: true
      end
    end
  end
end
