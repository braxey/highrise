# require "application_system_test_case"

# class OrganizationMembershipsTest < ApplicationSystemTestCase
#   setup do
#     @organization_membership = organization_memberships(:one)
#   end

#   test "visiting the index" do
#     visit organization_memberships_url
#     assert_selector "h1", text: "Organization memberships"
#   end

#   test "should create organization membership" do
#     visit organization_memberships_url
#     click_on "New organization membership"

#     click_on "Create Organization membership"

#     assert_text "Organization membership was successfully created"
#     click_on "Back"
#   end

#   test "should update Organization membership" do
#     visit organization_membership_url(@organization_membership)
#     click_on "Edit this organization membership", match: :first

#     click_on "Update Organization membership"

#     assert_text "Organization membership was successfully updated"
#     click_on "Back"
#   end

#   test "should destroy Organization membership" do
#     visit organization_membership_url(@organization_membership)
#     click_on "Destroy this organization membership", match: :first

#     assert_text "Organization membership was successfully destroyed"
#   end
# end
