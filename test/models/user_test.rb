require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user with invalid email" do
    user = User.new(email_address: "invalid", password: "password")
    assert_not user.save
  end

  test "should not save user with existing email" do
    User.create(email_address: "test@gillyware.com", password: "password")
    user = User.new(email_address: "test@gillyware.com", password: "another_password")
    assert_not user.save
  end

  test "should not save user with password shorter than 8 characters" do
    user = User.new(email_address: "test@gillyware.com", password: "short")
    assert_not user.save
  end

  test "should save valid user" do
    user = User.new(email_address: "test@gillyware.com", password: "password")
    assert user.save
  end
end
