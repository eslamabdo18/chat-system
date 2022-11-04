class Api::V1::MessagesController < ApplicationController
    # before_action :set_application
    before_action :set_chat
    
    #GET /api/v1/applications/:app_token/chats/:number/messages
    def index
      @messages = @chat.messages.all
      json_response(@messages)
    end
    #GET /api/v1/applications/:app_token/chats/:number/messages/:number
    def show
      @message = @chat.messages.find_by!(number:message_params[:number])
      json_response(@message)
    end

    def search
      # Message.import(force: true)
      puts 'start search'
      res = Message.search(params[:query], fields: [:body],where: {chat_id: [@chat.id]})
      json_response(res.each { |r| })
      # json_response(Message.search(params[:query], @chat.id))
    end

    private
    
    def message_params
        params.permit(:number)
    end
    def set_chat
      @application = Application.find_by!(app_token:params[:application_app_token])
      @chat = @application.chats.find_by!(number:params[:chat_number])
    end
end
