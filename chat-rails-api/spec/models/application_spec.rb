require 'rails_helper'

RSpec.describe Application, type: :model do
  # ensure Application model has a 1:m relationship with the Chat model
  it { should have_many(:chats).dependent(:destroy) }
  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:chat_count) }
end
