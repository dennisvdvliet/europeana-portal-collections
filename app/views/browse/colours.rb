module Browse
  class Colours < ApplicationView
    def page_title
      mustache[:page_title] ||= begin
        [t('site.browse.colours.title'), site_title].join(' - ')
      end
    end

    def content
      mustache[:content] ||= begin
        {
          title: page_title,
          description: t('site.browse.colours.description'),
          colours: {
            title: page_title,
            items: @colours.map do |colour|
              {
                hex: colour.value,
                label: t('X11.colours.' + (colour.value.sub '#', ''), locale: 'en', default: colour.value),
                num_results: colour.hits,
                url: search_path(f: { 'COLOURPALETTE' => [colour.value], 'TYPE' => ['IMAGE'] })
              }
            end
          }
        }
      end
    end

    def head_meta
      mustache[:head_meta] ||= begin
        [
          { meta_name: 'description', content: page_title }
        ] + super
      end
    end

    private

    def body_cache_key
      'browse/colours'
    end
  end
end
