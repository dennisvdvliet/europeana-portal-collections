module Home
  class Index < ApplicationView
    def page_title
      'Europeana Collections - Alpha'
    end

    def content
      {
        hero_config: hero_config(@landing_page.hero_image),
        strapline: t('site.home.strapline', total_item_count: total_item_count),
#        promoted: config[:content][:promoted],
        news: blog_news_items.blank? ? nil : {
          items: blog_news_items,
          blogurl: 'http://blog.europeana.eu/'
        }
      }
    end

    private

    def blog_news_items
      @blog_news_items ||= news_items(@blog_items)
    end
  end
end
