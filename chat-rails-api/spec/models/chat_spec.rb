require 'rails_helper'

RSpec.describe Chat, type: :model do
  # ensure an chat record belongs to a single application record
  it { should belong_to(:application) }
  # ensure Chat model has a 1:m relationship with the Message model
  it { should have_many(:messages).dependent(:destroy) }

  it { should validate_presence_of(:number) }
end
