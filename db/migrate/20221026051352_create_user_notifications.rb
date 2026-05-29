class CreateUserNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :user_notifications do |t|
      t.integer :transformer_id
      t.string  :user_id
      t.date    :date_notification
      t.string  :description 
      t.integer :state
      t.integer :deleted

      t.timestamps
    end
  end
end
