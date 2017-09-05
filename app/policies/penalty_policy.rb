class PenaltyPolicy < ApplicationPolicy
  def destroy?
  	# Non assignee
    @user != record.user
  end

  def approve?
  	# Non creator can approve
    record.unconfirmed? && ((@user != record.creator) || (@user == record.user))
  end

  def update?
  	record.unconfirmed
  end
end
