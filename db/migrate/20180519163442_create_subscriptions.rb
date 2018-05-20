class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :stripe_user_id
      t.string :card_brand
      t.string :card_last4
      t.string :card_exp_month
      t.string :card_exp_year
      t.datetime :expires_at
      t.boolean :active, null: false, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
