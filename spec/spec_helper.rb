ENV['RAILS_ENV'] ||= 'test'
ENV['USE_SAUCE'] ||= 'false'
ENV['HEROKU'] ||= 'false'

if ENV['HEROKU'] != 'true'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
end

require "watir_drops"
require "watir_model"
require 'require_all'
require 'webdrivers'

require_rel "support/site"
require_rel "support/data"
require_rel "support/pages"

require_rel "support/sauce_helpers" if ENV['USE_SAUCE'] == 'true'

include AddressBook
include Page

RSpec.configure do |config|

  config.include SauceHelpers if ENV['USE_SAUCE'] == 'true'

  config.before(:each) do |test|
    @browser = if ENV['USE_SAUCE'] == 'true'
                 initialize_driver(test.full_description)
               else
                 Watir::Browser.new
               end

    Base.browser = @browser
    Site.browser = @browser
    Site.base_url = if ENV['HEROKU'] != 'true'
                      #"http://#{Watir::Rails.host}:#{Watir::Rails.port}"
                      "http://localhost:3000"
                    else
                      'https://address-book-example.herokuapp.com'
                    end
    @browser.window.maximize
  end

  config.after(:each) do |example|
    submit_results(@browser.wd.session_id, !example.exception) if @browser.wd.respond_to? :session_id
    @browser.quit
  end
end
