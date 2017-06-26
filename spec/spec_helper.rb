ENV['RAILS_ENV'] ||= 'test'
ENV['USE_SAUCE'] ||= 'true'
ENV['HEROKU'] ||= 'true'

if ENV['HEROKU'] != 'true'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
end

require "watir_drops"
require "watir_model"
require 'require_all'
require 'saucer'

require_rel "support/site"
require_rel "support/data"
require_rel "support/pages"

include AddressBook
include Page

RSpec.configure do |config|

  config.before(:each) do
    @browser = if ENV['USE_SAUCE'] == 'true'
                 Watir::Browser.new(Saucer::Driver.new)
               else
                 Watir::Browser.new
               end

    Base.browser = @browser
    Site.base_url = if ENV['HEROKU'] != 'true'
                      "http://#{Watir::Rails.host}:#{Watir::Rails.port}"
                    else
                      'https://address-book-example.herokuapp.com'
                    end
  end

  config.after(:each) do
    @browser.quit
  end
end
