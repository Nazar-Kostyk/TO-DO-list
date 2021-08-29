class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.text :description
      t.integer :position
      t.belongs_to :to_do_list, index: true

      t.timestamps
    end
  end
end
