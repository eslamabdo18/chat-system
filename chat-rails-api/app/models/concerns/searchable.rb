module Searchable
    extend ActiveSupport::Concern
  
    included do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks
      include Elasticsearch::Model::Indexing

      after_commit :reindex_model
    #   after_commit :reindex
  
        settings do
            mapping dynamic: false do
            indexes :body, type: :text, analyzer: :english
            indexes :chat_id
            end
        end
    
      def as_indexed_json(options={})
        self.as_json(only: [:body, :number, :chat_id])
      end
      def self.search(query, chat_id)
        response = __elasticsearch__.search(
            query: {
                bool: {
                    must: [
                        { match: { chat_id: chat_id } },
                        { query_string: { query: "*#{query}*", fields: [:body] } }
                    ]
                }
            }
        )
        response.results.map { |r| {body: r._source.body, number: r._source.number} }
      end

      private
      def reindex_model
        put "tryinng to reindex"
        __elasticsearch__.index_document
        import(force: true)
      end
    end
end