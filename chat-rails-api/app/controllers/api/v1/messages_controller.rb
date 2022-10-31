class MessagesController < ApplicationController
    before_action :set_chat, only: [:show, :index]

    #GET /api/v1/applications/:app_token/chats/:number/messages
    def index
      @messages = @chat.messages.all
      json_response(@messages)
    
    #GET /api/v1/applications/:app_token/chats/:number/messages/:number
    def show
      @message = @chat.messages.find_by!(number:message_params[:number])
    

    private
    
    def message_params
        params.permit(:number)
    end
    def set_chat
        @application = Application.find_by!(app_token:params[:application_app_token])
        @chat = @application.chats.find_by!(number:params[:chat_number])
    end
end
