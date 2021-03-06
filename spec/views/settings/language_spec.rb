RSpec.describe 'settings/language.html.mustache', :page_with_top_nav do
  before(:each) do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = false
      end
    end

    allow(view).to receive(:settings).and_return(
      language: {
        language_default: {
          title: 'Default Language',
          items: [
            { text: 'English' }, { text: 'French' }
          ]
        }
      }
    )

    Stache::ViewContext.current = view
  end

  it 'should have page title' do
    render
    expect(rendered).to have_css('title', visible: false, text: /Language settings/i)
  end

  it 'should have default language field' do
    render
    expect(rendered).to have_select('locale', with_options: ['English', 'Dutch'])
  end
end
