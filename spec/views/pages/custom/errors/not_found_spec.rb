require 'support/shared_examples/page_with_top_nav'

RSpec.describe 'pages/custom/errors/not_found.html.mustache' do
  let(:blacklight_config) do
    Blacklight::Configuration.new do |config|
      config.index.title_field = 'title_display'
    end
  end

  before(:each) do
    assign(:page, page)
    allow(controller).to receive(:blacklight_config).and_return(blacklight_config)
    allow(view).to receive(:blacklight_config).and_return(blacklight_config)
  end

  let(:page) { pages(:not_found) }

  it_should_behave_like 'page with top nav'

  it 'should have page title' do
    render
    expect(rendered).to have_selector('title', visible: false, text: /\A#{page.title}/)
  end

  it 'should have intro para' do
    render
    expect(rendered).to have_selector('section.page-header p', text: page.body)
  end

  it 'should display search form' do
    render
    expect(rendered).to have_selector('form.search-multiterm input.search-input[type="text"]')
  end
end
