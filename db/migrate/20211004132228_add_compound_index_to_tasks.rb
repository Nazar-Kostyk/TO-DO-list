# frozen_string_literal: true

class AddCompoundIndexToTasks < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        add_index :tasks, %i[to_do_list_id position], unique: true
      end

      dir.down do
        remove_index :tasks, %i[to_do_list_id position]
      end
    end
  end
end
