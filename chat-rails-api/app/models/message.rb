class Message < ApplicationRecord
  include ElasticsearchIndexer
  searchkick callbacks: false
  belongs_to :chat, counter_cache: :message_count, touch: true

  # def search_data
  #   {
  #     body: body,
  #     number: number
  #   }
  # end
  validates_presence_of :number
  validates :number,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 },
            uniqueness: { scope: :chat_id }
  
  
  

end
