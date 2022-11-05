FactoryBot.define do
    factory :chat do
      sequence(:number) { |n| n }
      association :application, factory: :application
      message_count {0}
    end
end