class CreateToDoLists < ActiveRecord::Migration[6.1]
  def change
    create_table :to_do_lists, id: :uuid do |t|
      t.string :name
      t.text :description
      t.belongs_to :user, index: :true

      t.timestamps
    end
  end
end
