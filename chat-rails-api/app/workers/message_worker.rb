class MessageWorker
    include Sidekiq::Worker
    sidekiq_options queue: :message
    def perform(app_token, chat_number, number, body)
        puts 'hereeeeeeeeee'
        puts chat_number
        logger.debug('hereeeeeeeeeeeeeeeeeeeeeeee')
        application = Application.find_by!(app_token: app_token)
        chat = application.chats.find_by!(number: chat_number)
        logger.debug('hereeeeeeeeeeeeeeeeeeeeeeee')
        puts 'afterrrrr createing chatttt'
        puts chat.messages
        chat.messages.create!(number: number, body: body)
        puts 'jsdshdhsassadsadasaasadasaddasdasdasdasddasdsadassadasdasdasdadsd'
        # msg.__elasticsearch__.index_document
        # Message.import(force: true)
    end
end