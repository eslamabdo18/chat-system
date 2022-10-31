class ChatWorker
    include Sidekiq::Worker
    sidekiq_options queue: :chat
    def perform(app_token, number)
        application = Application.find_by!(app_token: app_token)
        application.chats.create!(number: number, message_count: 0)
    end
end