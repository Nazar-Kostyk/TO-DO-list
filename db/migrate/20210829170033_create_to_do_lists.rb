# frozen_string_literal: true

class CreateToDoLists < ActiveRecord::Migration[6.1]
  def change
    create_table :to_do_lists, id: :uuid do |t|
      t.string :title, limit: 255, default: 'Untitled'
      t.text :description, null: true
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
