require 'bundler/setup'
app_file = File.join File.dirname(__FILE__), '..', 'app.rb'
require app_file
require 'capybara/rspec'

Capybara.app = Sinatra::Application

def test_file name
  File.join File.dirname(__FILE__), 'xml', name
end

describe 'validate some xml', :type => :acceptance do

  it 'should return no errors for a good document' do
    visit '/'
    attach_file 'xml', test_file('good.xml')
    click_button 'validate'
    page.should have_selector('table.errors tr.error')
  end

  it 'should return some errors for a bad document' do
    visit '/'
    attach_file 'xml', test_file('bad.xml')
    click_button 'validate'
    page.should have_selector('table.errors tr.error')
  end

end
