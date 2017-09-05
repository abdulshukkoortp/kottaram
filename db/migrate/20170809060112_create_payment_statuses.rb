class CreatePaymentStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_statuses do |t|
      t.integer :user_id
      t.boolean :paid, default: false
      t.text :year_month
      t.timestamps
    end
  end
end
