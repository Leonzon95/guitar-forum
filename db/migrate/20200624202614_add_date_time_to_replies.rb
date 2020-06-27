class AddDateTimeToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :created_at, :datetime
  end
end
