FactoryBot.define do
    factory :message do
      sequence(:number) { |n| n }
      association :chat, factory: :chat
      body { Faker::Lorem.word }
    end
end