ENV['RAILS_ENV'] ||= 'test'
ENV['USE_SAUCE'] ||= 'true'
ENV['NO_HEROKU'] ||= 'false'
ENV['NO_API'] ||= 'false'

if ENV['NO_HEROKU'] == 'true'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
end

require "watir_drops"
require "watir_model"
require 'require_all'

require_rel "support"

RSpec.configure do |config|

  config.include SauceHelpers
  config.include Test

  config.before(:each) do |test|
    @browser = if ENV['USE_SAUCE'] == 'true'
                 initialize_driver(test.full_description)
               else
                 Watir::Browser.new
               end

    BasePage.browser = @browser
    BasePage.base_url = if ENV['NO_HEROKU'] == 'true'
                          "http://#{Watir::Rails.host}:#{Watir::Rails.port}"
                        else
                          'https://address-book-example.herokuapp.com'
                        end
  end

  config.after(:each) do |example|
    submit_results(@browser.wd.session_id, !example.exception) if @browser.wd.respond_to? :session_id
    @browser.quit
  end
end

