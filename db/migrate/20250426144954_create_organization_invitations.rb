class CreateOrganizationInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :organization_invitations do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :role, foreign_key: true
      t.string :email_address, null: false
      t.string :token, null: false
      t.string :status, null: false, default: "pending"
      t.datetime :accepted_at
      t.datetime :denied_at
      t.references :invited_by, foreign_key: { to_table: :users }, null: false
      t.timestamps
    end

    add_index :organization_invitations, :token, unique: true
  end
end
