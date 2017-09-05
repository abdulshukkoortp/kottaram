class CreatePenalties < ActiveRecord::Migration[5.0]
  def change
    create_table :penalties do |t|
      t.integer :user_id
      t.date :date
      t.integer :type
      t.float :amount
      t.timestamps
      t.integer :creator_id
      t.integer :approver_id
      t.integer :status, default: 0
      t.text :description
    end
  end
end
