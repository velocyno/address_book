module Addresses
  class New < BasePage

    page_url(required: true) { "#{BasePage.base_url}/addresses/new" }

    element(:first_name) { browser.text_field(id: 'address_first_name') }
    element(:last_name) { browser.text_field(id: 'address_last_name') }
    element(:street_address) { browser.text_field(id: 'address_street_address') }
    element(:secondary_address) { browser.text_field(id: 'address_secondary_address') }
    element(:city) { browser.text_field(id: 'address_city') }
    element(:state) { browser.text_field(id: 'address_state') }
    element(:zip_code) { browser.text_field(id: 'address_zip_code') }
    element(:note) { browser.textarea(id: 'address_note') }
    element(:submit) { browser.button(data_test: 'submit') }

    def submit_form(address = nil)
      address ||= Test::Address.new
      fill_form(address)
      submit.click
      browser.wait_while { on_page? }
      address.tap { |a| a.id = browser.url[/\d+$/] }
    end

  end
end
