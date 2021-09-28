# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title, limit: 255, default: 'Untitled'
      t.integer :position, index: { unique: true }, null: false
      t.boolean :is_completed, default: false
      t.references :to_do_list, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
