class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :scope, null: false
      t.timestamps
    end
    add_index :roles, [ :name, :scope ], unique: true
  end
end
