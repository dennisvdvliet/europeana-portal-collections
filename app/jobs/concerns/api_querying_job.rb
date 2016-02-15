module ApiQueryingJob
  extend ActiveSupport::Concern

  include Blacklight::RequestBuilders

  def blacklight_config
    @blacklight_config ||= PortalController.new.blacklight_config
  end

  def repository
    @repository ||= repository_class.new(blacklight_config)
  end

  def repository_class
    blacklight_config.repository_class
  end

  def cache_query_count(api_query, cache_key)
    repository.search(api_query).total.tap do |count|
      Rails.cache.write(cache_key, count)
    end
  end
end
