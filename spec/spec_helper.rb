ENV['RAILS_ENV'] ||= 'test'
ENV['USE_SAUCE'] ||= 'false'
ENV['BASE_SITE'] ||= 'rails'

if ENV['NO_HEROKU'] == 'true'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
end

require "watir_drops"
require "watir_model"
require 'require_all'

require_rel "support/site"
require_rel "support/data"
require_rel "support/pages"

require_rel "support/sauce_helpers" if ENV['USE_SAUCE'] == 'true'

include AddressBook

RSpec.configure do |config|

  config.include SauceHelpers if ENV['USE_SAUCE'] == 'true'

  config.before(:each) do |test|
    @browser = if ENV['USE_SAUCE'] == 'true'
                 initialize_driver(test.full_description)
               else
                 Watir::Browser.new
               end

    AddressBook::Base.browser = @browser
    AddressBook::Base.base_url = case ENV['BASE_SITE']
                                 when 'local'
                                   'http://localhost:3000'
                                 when 'heroku'
                                   'https://address-book-example.herokuapp.com'
                                 else
                                   "http://#{Watir::Rails.host}:#{Watir::Rails.port}"
                                 end
  end

  config.after(:each) do |example|
    submit_results(@browser.wd.session_id, !example.exception) if @browser.wd.respond_to? :session_id
    @browser.quit
  end
end

