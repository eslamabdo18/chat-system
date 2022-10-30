FactoryBot.define do
    factory :application do
      name { Faker::Lorem.word }
      chat_count {0}
    end
end