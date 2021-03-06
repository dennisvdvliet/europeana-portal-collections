RSpec.describe 'home/index.html.mustache', :page_with_top_nav do
  let(:europeana_item_count) { 1234 }

  let(:blacklight_config) do
    Blacklight::Configuration.new do |config|
      config.index.title_field = 'title_display'
    end
  end

  let(:landing_page) { Page::Landing.find_by_slug('') }

  let(:collection) { Collection.find_by_key('home') }

  before(:each) do
    allow(controller).to receive(:blacklight_config).and_return(blacklight_config)
    allow(view).to receive(:blacklight_config).and_return(blacklight_config)
    assign(:europeana_item_count, europeana_item_count)
    assign(:landing_page, landing_page)
    assign(:collection, collection)
  end

  it 'should have meta description' do
    meta_content = I18n.t('site.home.strapline', total_item_count: europeana_item_count)
    meta_content = meta_content.strip! || meta_content
    render
    expect(rendered).to have_selector("meta[name=\"description\"][content=\"#{meta_content}\"]", visible: false)
  end

  it 'should have meta HandheldFriendly' do
    render
    expect(rendered).to have_selector("meta[name=\"HandheldFriendly\"]", visible: false)
  end
end
