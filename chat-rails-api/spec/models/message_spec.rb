require 'rails_helper'

RSpec.describe Message, type: :model do
   # ensure an message record belongs to a single chat record
   it { should belong_to(:chat) }

   it { should validate_presence_of(:number) }
end
