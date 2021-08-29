class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :admins, id: :uuid do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
