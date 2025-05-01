# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Create the user admin role
role = Role.find_or_create_by!(scope: Constants::Roles::Scopes::USER, name: Constants::Roles::Names::ADMIN) do |r|
  r.scope = Constants::Roles::Scopes::USER
  r.name = Constants::Roles::Names::ADMIN
end

# Create the Gillyware organization
Organization.find_or_create_by!(name: "Gillyware, LLC") do |org|
  org.name = "Gillyware, LLC"
  org.is_active = true
end

# Create the user admin user
User.find_or_create_by!(email_address: "braxeyy@gmail.com") do |u|
  u.email_address = "braxeyy@gmail.com"
  u.first_name = "Bradley"
  u.last_name = "Johnson"
  u.password = "gilgamesh"
  u.role_id = role.id
end
