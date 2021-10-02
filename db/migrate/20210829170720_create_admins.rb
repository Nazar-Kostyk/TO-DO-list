# frozen_string_literal: true

class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :admins, id: :uuid do |t|
      t.string :name, limit: 255, null: false
      t.string :surname, limit: 255, null: false
      t.string :email, index: { unique: true }, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
