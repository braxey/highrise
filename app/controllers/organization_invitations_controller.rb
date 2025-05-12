class OrganizationInvitationsController < ApplicationController
  before_action :set_organization
  before_action :set_organization_invitation, only: %i[ show edit update destroy handle_invitation_response ]
  before_action :only_allow_invited, only: %i[ show handle_invitation_response ]
  before_action :only_for_pending_invites, only: %i[ edit update destroy handle_invitation_response ]

  def index
    @per_page = 8

    @current_page = params[:page].to_i || 1
    @current_page = 1 if @current_page < 1
    offset = (@current_page - 1) * @per_page

    @search_query = params[:search].to_s || ""

    @query = @organization.organization_invitations.pending

    if @search_query.present?
      @query = @query.where("email_address LIKE ?", "%#{@search_query}%")
    end

    @total_invitations = @query.count
    @last_page = (@total_invitations/@per_page.to_f).ceil
    @start_number = [ offset + 1, @total_invitations ].min
    @end_number = [ offset + @per_page, @total_invitations ].min

    @organization_invitations = @query.includes(:role).limit(@per_page).offset(offset)
  end

  def new
    @organization_invitation = @organization.organization_invitations.build
  end

  def show
    if not prefetching?
      @organization_invitation.notification.update(read: true)
    end
  end

  def edit
  end

  def create
    email = organization_invitation_params[:email_address]&.strip.downcase
    @organization_invitation = @organization.organization_invitations.pending.find_by(email_address: email) || @organization.organization_invitations.build

    if @organization_invitation.persisted?
      @organization_invitation.errors.add(:email_address, "already has a pending invitation.")
      return render :new, status: :unprocessable_entity
    end

    @organization_invitation.assign_attributes(
      email_address: email,
      role_id: Role.where(id: organization_invitation_params[:role]).first&.id,
      invited_by: session_user,
      status: "pending",
      accepted_at: nil,
      denied_at: nil,
    )

    if @organization_invitation.save
      Notification.create!(
        email_address: email,
        notifiable: @organization_invitation,
        message: "You're invited to join #{@organization.name}. Click here to respond to the invite.",
      )

      redirect_to new_organization_organization_invitation_path(@organization), flash: { success: "Sent" }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @organization_invitation.update(role_id: Role.where(id: organization_invitation_params[:role]).first&.id)
      redirect_to edit_organization_organization_invitation_path(@organization), flash: { success: "Saved" }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization_invitation.notification.destroy!
    @organization_invitation.destroy!
    redirect_to organization_organization_invitations_path(@organization), status: :see_other
  end

  def handle_invitation_response
    if params[:invite_accepted] == "true"
      @organization_invitation.update!(status: "accepted", accepted_at: Time.current)

      @organization.organization_memberships.create!(
        user: session_user,
        role: @organization_invitation.role
      )

      redirect_to organization_path(@organization)
    else
      @organization_invitation.update!(status: "denied", denied_at: Time.current)
      redirect_to dashboard_path
    end
  end

  private
    def set_organization
      @organization = Organization.find(params.expect(:organization_id))
    end

    def set_organization_invitation
      @organization_invitation = @organization.organization_invitations.find_by!(token: params[:token])
    end

    def only_allow_invited
      unless session_user&.email_address == @organization_invitation.email_address
        redirect_to root_path
      end
    end

    def only_for_pending_invites
      unless @organization_invitation.status == "pending"
        redirect_to root_path
      end
    end

    def organization_invitation_params
      params.expect(organization_invitation: [ :email_address, :role ])
    end
end
