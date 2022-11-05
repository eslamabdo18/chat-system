require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let!(:messages) {create_list(:message, 10) }
  let(:message_number) { messages.first.number}
  let(:chat_number) { messages.first.chat.number}
  let(:chat) { messages.first.chat}
  let(:app_token) { messages.first.chat.application.app_token}
  # let(:application) {chats.first.application}
  describe "GET /api/v1/applications/:token/chats/:chat_number/messages" do
    # make HTTP get request before each example
    before { get "/api/v1/applications/#{app_token}/chats/#{chat_number}/messages" }
    it 'returns messages' do
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'the message_count in the chat is 1' do 
      expect(chat.message_count).to eq(1)
    end
  end

  describe "GET /api/v1/applications/:token/chats/:chat_number/messages/:number" do
     # make HTTP get request before each example
    before { get "/api/v1/applications/#{app_token}/chats/#{chat_number}/messages/#{message_number}" }
    
    context 'when the record exists' do
      it 'returns the chat' do
        expect(json).not_to be_empty
        expect(json['number']).to eq(message_number)
      end

      it 'id feild dosent return' do
        expect(json).not_to be_empty
        expect(json['id']).to be_nil 
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end


    context 'when the record exists' do
      let(:message_number) { 'jdjjdmadmweeqk' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Message/)
      end
    end
  end
end
