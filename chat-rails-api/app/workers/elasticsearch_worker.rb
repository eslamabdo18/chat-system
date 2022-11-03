class ElasticsearchWorker
    include Sidekiq::Worker
    sidekiq_options queue: :index
    def perform(id, klass)
        puts 'starttttttt indexing'
      begin
        object = klass.constantize.find(id.to_s).reindex
      rescue => e
        Rails.logger '-------------Exception---------------------'
        Rails.logger "-------------#{e.message}------------------"
        Rails.logger '-------------------------------------------'
      end
    end
end