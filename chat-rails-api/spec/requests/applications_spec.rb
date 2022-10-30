require 'rails_helper'

RSpec.describe "Applications", type: :request do
  # initialize test data
  let!(:applications) { create_list(:application, 10) }
  let(:app_access_token) { applications.first.access_token }

  describe "GET /api/v1/applications" do
    # make HTTP get request before each example
    before { get '/api/v1/applications' }

    it 'returns applications' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /appliccations/:access_token
  describe 'GET /api/v1/applications/:access_token' do
    before { get "/api/v1/applications/#{app_access_token}" }

    context 'when the record exists' do

      it 'returns the application' do
        expect(json).not_to be_empty
        expect(json['access_token']).to eq(app_access_token)
      end

      it 'id feild dosent return' do
        expect(json).not_to be_empty
        expect(json['id']).to be_nil 
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:app_access_token) { 'jdjjdmadmweeqk' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Application/)
      end
    end
  end

  # Test suite for POST /appliccations
  describe 'POST /api/v1/applications' do
    # valid payload
    let(:valid_attributes) { { name: 'instabug', chat_count: 0 } }

    context 'when the request is valid' do
      before { post '/api/v1/applications', params: valid_attributes }

      it 'creates a todo' do
        expect(json['name']).to eq('instabug')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/applications', params: {  } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end
end
