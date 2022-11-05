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
      @message = @chat.messages.find_by!(number:params[:number])
      json_response(@message)
    end

    # PUT /api/v1/applications/:app_token/chats/:chat_number/messages/:messages_number
    def update
      @message = @chat.messages.find_by!(number:params[:number])
      @message.update!(message_params)
      head :no_content
    end

    def search
      res = Message.search(params[:query], fields: [:body],where: {chat_id: [@chat.id]})
      json_response(res.each { |r| })
    end

    private
    
    def message_params
        params.permit(:body)
    end
    def set_chat
      @application = Application.find_by!(app_token:params[:application_app_token])
      @chat = @application.chats.find_by!(number:params[:chat_number])
    end
end
