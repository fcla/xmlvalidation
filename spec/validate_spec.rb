app_file = File.join File.dirname(__FILE__), '..', 'app.rb'

require app_file
require 'capybara/rspec'

Capybara.app = Sinatra::Application

describe 'validate some xml', :type => :request do
  it 'should return no errors for a good document' do
    visit '/'
    attach_file 'xml', 'foo'
    click_button 'validate'
  end

  it 'should return errors for a good document'
  it 'should return no errors for a good document'
end
