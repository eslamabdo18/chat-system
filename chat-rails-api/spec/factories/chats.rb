FactoryBot.define do
    factory :chat do
      name { Faker::Lorem.word }
      application_id nil
      message_count {0}
    end
end