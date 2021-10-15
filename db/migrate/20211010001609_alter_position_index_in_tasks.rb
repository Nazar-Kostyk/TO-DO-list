# frozen_string_literal: true

class AlterPositionIndexInTasks < ActiveRecord::Migration[6.1]
  def up
    remove_index :tasks, %i[to_do_list_id position]
    execute <<~SQL.squish
      ALTER TABLE tasks
        ADD CONSTRAINT index_tasks_on_to_do_list_id_and_position UNIQUE (to_do_list_id, position)
        DEFERRABLE INITIALLY IMMEDIATE;
    SQL
  end

  def down
    execute <<~SQL.squish
      ALTER TABLE tasks
        DROP CONSTRAINT index_tasks_on_to_do_list_id_and_position;
    SQL
    add_index :tasks, %i[to_do_list_id position], unique: true
  end
end
