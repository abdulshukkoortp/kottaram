class Splitwise < ApplicationRecord
  belongs_to :creator, class_name: :User, foreign_key: :created_by
  belongs_to :purchasee, class_name: :User, foreign_key: :purchased_by
  before_validation :convert_to_utc

  validates :price, presence: true

  scope :monthly_purchase, -> (date) {where('purchased_at >=? and purchased_at <= ?',
  	date.beginning_of_month, date.end_of_month)}
  class << self
    def analysis(date_time)
	    monthly_purchase = monthly_purchase(date_time).order('purchased_at DESC')
	  end

		def total_expense(date_time)
			cost = cost_of_purchase
      total_penalty = Penalty.billable_penalty_amount(date_time)
		  # Considering only one house now
		  rent = HouseInfo.first.try(:rent).to_f
		  total_expense = cost + rent - total_penalty
		end

		def cost_of_purchase
		  sum(&:price).to_f
		end
  end

  private

  def convert_to_utc
  	self.purchased_at = Time.parse("#{self.purchased_at}").utc.iso8601 if purchased_at
  end
end
