##
# URL helpers
#
# @see Blacklight::UrlHelperBehavior
module UrlHelper
  include Blacklight::UrlHelperBehavior

  ##
  # Remove one value from an Array of params
  #
  # @param key [Symbol, String] Key of parameter to remove
  # @param value Value to remove from params
  # @param source_params [Hash] params to remove from
  # @return [Hash] a copy of params with the passed value removed
  def remove_search_param(key, value, source_params = params)
    p = Blacklight::SearchState.new(source_params, blacklight_config).send(:reset_search_params)
    p[key] = ([p[key]].flatten || []).dup
    p[key] = p[key] - [value]
    p.delete(key) if p[key].empty?
    p
  end

  ##
  # Remove q param, shifting first qf param (if any) to q
  #
  # @param source_params [Hash] params to operate on
  # @return [Hash] modified params
  def remove_q_param(source_params = params)
    Blacklight::SearchState.new(source_params, blacklight_config).send(:reset_search_params).tap do |p|
      if p[:qf].blank?
        p.delete(:q)
      elsif p[:qf].is_a?(Array)
        p[:q] = p[:qf].shift
      else
        p[:q] = p.delete(:qf)
      end
    end
  end

  # @param page [Page]
  # @param browse_entry [BrowseEntry]
  # @return [String] url
  def browse_entry_url(browse_entry, page = nil)
    browse_entry_query = Rack::Utils.parse_nested_query(browse_entry.query)
    if page.present? && (slug_match = page.slug.match(/\Acollections\/(.*)\Z/))
      collection = Collection.find_by_key(slug_match[1])
      return collection_path(collection.key, browse_entry_query) unless collection.nil?
    end
    search_path(browse_entry_query)
  end
end
