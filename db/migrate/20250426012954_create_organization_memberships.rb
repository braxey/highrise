class CreateOrganizationMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :organization_memberships do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :role, foreign_key: true
      t.timestamps
    end
    add_index :organization_memberships, [ :organization_id, :user_id ], unique: true
  end
end
