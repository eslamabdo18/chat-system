class Api::V1::ApplicationsController < ApplicationController
    before_action :set_application, only: [:show, :update]

    # GET /api/v1/applications
    def index
        @applications = Application.all
        json_response(@applications)
    end

    # POST /api/v1/applications
    def create
        @application = Application.create!(application_params.merge({chat_count: 0}))
        json_response(@application, :created)
    end

    # GET /api/v1/applications/:app_token
    def show
        json_response(@application)
    end

    # PUT /api/v1/applications/:app_token
    def update
        @application.update!(application_params)
        head :no_content
    end

    private

    def application_params
        params.permit(:name)
    end

    def set_application
        @application = Application.find_by!(app_token: params[:app_token])
    end
end
