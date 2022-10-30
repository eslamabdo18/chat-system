class Application < ApplicationRecord
    has_secure_token :access_token
    has_many :chats, dependent: :destroy

    validates_presence_of :name, :chat_count
end
