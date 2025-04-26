# require "test_helper"

# class UserTest < ActiveSupport::TestCase
#   test "should not save user with invalid email" do
#     user = User.new(email_address: "invalid", password: "password", first_name: "Bradley", last_name: "Johnson")
#     assert_not user.save
#   end

#   test "should not save user with existing email" do
#     user_one = users(:one)
#     user = User.new(email_address: user_one.email_address, password: "another_password", first_name: "Bradley", last_name: "Johnson")
#     assert_not user.save
#   end

#   test "should not save user with password shorter than 8 characters" do
#     user = User.new(email_address: "test@gillyware.com", password: "short", first_name: "Bradley", last_name: "Johnson")
#     assert_not user.save
#   end

#   test "should save valid user" do
#     user = User.new(email_address: "test@gillyware.com", password: "password", first_name: "Bradley", last_name: "Johnson")
#     assert user.save
#   end
# end
