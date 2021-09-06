# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title, limit: 255, default: 'Untitled'
      t.integer :position, unique: true, null: false
      t.boolean :is_completed, default: false
      t.belongs_to :to_do_list, index: true

      t.timestamps
    end
  end
end
