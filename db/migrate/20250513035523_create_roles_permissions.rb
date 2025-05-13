class CreateRolesPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :roles_permissions do |t|
      t.references :role, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true

      t.timestamps
    end

    add_index :roles_permissions, [ :role_id, :permission_id ], unique: true
  end
end
