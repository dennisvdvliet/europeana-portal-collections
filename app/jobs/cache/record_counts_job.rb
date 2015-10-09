class Cache::RecordCountsJob < ActiveJob::Base
  include ApiQueryingJob

  queue_as :default

  def perform
    sets.each_pair do |key, set_params|
      params = set_params.merge(rows: 0, profile: 'minimal')
      count = repository.search(params).total

      cache_key = "record/counts/#{key}"
      Rails.cache.write(cache_key, count)
    end
  end

  protected

  def sets
    {
      all: { query: '*:*' }
    }.tap do |sets|
      %w(music art-history).each do |channel|
        channel_params = Channel.find(channel).config[:params]
        %w(IMAGE SOUND TEXT VIDEO 3D).each do |type|
          sets["channels/#{channel}/type/#{type.downcase}"] = channel_params.merge(query: "TYPE:#{type}")
        end
      end
    end
  end
end