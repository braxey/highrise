# require "test_helper"

# class OrganizationMembershipsControllerTest < ActionDispatch::IntegrationTest
#   setup do
#     @organization_membership = organization_memberships(:one)
#   end

#   test "should get index" do
#     get organization_memberships_url
#     assert_response :success
#   end

#   test "should get new" do
#     get new_organization_membership_url
#     assert_response :success
#   end

#   test "should create organization_membership" do
#     assert_difference("OrganizationMembership.count") do
#       post organization_memberships_url, params: { organization_membership: {} }
#     end

#     assert_redirected_to organization_membership_url(OrganizationMembership.last)
#   end

#   test "should show organization_membership" do
#     get organization_membership_url(@organization_membership)
#     assert_response :success
#   end

#   test "should get edit" do
#     get edit_organization_membership_url(@organization_membership)
#     assert_response :success
#   end

#   test "should update organization_membership" do
#     patch organization_membership_url(@organization_membership), params: { organization_membership: {} }
#     assert_redirected_to organization_membership_url(@organization_membership)
#   end

#   test "should destroy organization_membership" do
#     assert_difference("OrganizationMembership.count", -1) do
#       delete organization_membership_url(@organization_membership)
#     end

#     assert_redirected_to organization_memberships_url
#   end
# end
