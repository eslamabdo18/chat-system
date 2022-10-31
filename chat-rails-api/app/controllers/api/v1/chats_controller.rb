class Api::V1::ChatsController < ApplicationController
    before_action :set_application, only: [:show, :index]
    def index
        @chats = @application.chats.all
        json_response(@chats)
    end

    # GET /api/v1/applications/:app_token/chats/:number
    def show
        @chat = @application.chats.find_by(number:chat_params[:number])
        json_response(@chat)
    end
    private 
    def chat_params
        params.permit(:number)
    end
    def set_application
        @application = Application.find_by!(app_token: params[:application_app_token])
    end
end
