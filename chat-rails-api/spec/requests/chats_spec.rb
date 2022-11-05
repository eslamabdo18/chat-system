require 'rails_helper'

RSpec.describe "Chats", type: :request do
  let!(:chats) {create_list(:chat, 10) }
  let(:chat_number) { chats.first.number}
  let(:app_token) {chats.first.application.app_token}
  let(:application) {chats.first.application}
  describe "GET /api/v1/applications/:token/chats" do
    # make HTTP get request before each example
    before { get "/api/v1/applications/#{app_token}/chats" }
    it 'returns chats' do
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'the chat_count in the application is 1' do 
      expect(application.chat_count).to eq(1)
    end
  end

  describe "GET /api/v1/applications/:token/chats/:number" do
     # make HTTP get request before each example
    before { get "/api/v1/applications/#{app_token}/chats/#{chat_number}" }
    
    context 'when the record exists' do
      it 'returns the chat' do
        expect(json).not_to be_empty
        expect(json['number']).to eq(chat_number)
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
      let(:chat_number) { 'jdjjdmadmweeqk' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Chat/)
      end
    end
  end
end
