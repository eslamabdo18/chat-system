class Application < ApplicationRecord
    has_secure_token :app_token
    has_many :chats, dependent: :destroy

    validates_presence_of :name, :chat_count
end
