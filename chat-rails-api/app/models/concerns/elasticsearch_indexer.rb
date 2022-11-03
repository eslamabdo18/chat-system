module ElasticsearchIndexer
    extend ActiveSupport::Concern
  
    included do
      after_commit :reindex_model
  
      def reindex_model
        if (previous_changes.keys & search_data.stringify_keys.keys).present?
          ElasticsearchWorker.perform_async(self.id, self.class.name)
        end
      end
    end
end