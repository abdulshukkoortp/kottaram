class Penalty < ApplicationRecord
  belongs_to :user, class_name: :User, foreign_key: :user_id
  belongs_to :creator, class_name: :User, foreign_key: :creator_id
  belongs_to :approver, class_name: :User, foreign_key: :approver_id, optional: true

  enum type: %w(cleaning other)
  enum status: %w(unconfirmed confirmed)
  validates :amount, presence: true
  validates :approver, presence: true, if: :confirmed?

  scope :monthly_penalty, -> (date) {where('date >=? and date <= ?',
  	date.beginning_of_month.to_date, date.end_of_month.to_date)}
  scope :confirmed_penalties, -> {where(status: statuses['confirmed'])}
  class << self
    def analysis(date_time)
	    monthly_penalty(date_time).order('date DESC')
	  end

    def billable_penalty_amount(date_time)
      monthly_penalty(date_time).confirmed_penalties.sum(&:amount)
    end
  end
end
