# frozen_string_literal: true

class AddCompoundIndexToTasks < ActiveRecord::Migration[6.1]
  def up
    add_index :tasks, %i[to_do_list_id position], unique: true
  end

  def down
    remove_index :tasks, %i[to_do_list_id position]
  end
end
