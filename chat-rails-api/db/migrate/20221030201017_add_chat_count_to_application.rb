class AddChatCountToApplication < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :chat_count, :integer
  end
end
