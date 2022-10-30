module Response
    def json_response(object, status = :ok)
      render json: object, :except => [:id, :application_id, :chat_id], status: status
    end
end