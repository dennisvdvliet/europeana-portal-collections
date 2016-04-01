module Home
  class Index < ApplicationView
    def page_title
      'Europeana Collections'
    end

    def js_slsb_ld
      {
        context: 'http://schema.org',
        type: 'WebSite',
        url: root_url,
        potentialAction: {
          type: 'SearchAction',
          target: root_url + 'search?q={q}',
          query_input: 'required name=q'
        }
      }
    end

    def content
      mustache[:content] ||= begin
        {
          hero_config: hero_config(@landing_page.hero_image),
          strapline: t('site.home.strapline', total_item_count: total_item_count),
          promoted: @landing_page.promotions.blank? ? nil : promoted_items(@landing_page.promotions),
          news: blog_news_items.blank? ? nil : {
            items: blog_news_items,
            blogurl: Cache::FeedJob::URLS[:blog][:all].sub('/feed', '')
          },
          banner: banner_content(@landing_page.banner_id)
        }.reverse_merge(helpers.content)
      end
    end

    def head_meta
      mustache[:head_meta] ||= begin
        title = page_title
        description = truncate(I18n.t('site.home.strapline', total_item_count: @europeana_item_count), length: 350, separator: ' ')
        description = description.strip! || description
        hero = hero_config(@landing_page.hero_image)
        head_meta = [
          { meta_name: 'description', content: description },
          { meta_property: 'fb:app_id', content: '185778248173748' },
          { meta_name: 'twitter:card', content: 'summary' },
          { meta_name: 'twitter:site', content: '@EuropeanaEU' },
          { meta_property: 'og:site_name', content: title },
          { meta_property: 'og:description', content: description },
          { meta_property: 'og:url', content: root_url }
        ]
        head_meta << { meta_property: 'og:title', content: title } unless title.nil?
        head_meta << { meta_property: 'og:image', content: URI.join(root_url, hero[:hero_image]) } unless hero.nil?
        head_meta + super
      end
    end

    private

    def body_cache_key
      @landing_page.cache_key
    end

    def blog_news_items
      @blog_news_items ||= news_items(feed_entries(Cache::FeedJob::URLS[:blog][:all]))
    end
  end
end
