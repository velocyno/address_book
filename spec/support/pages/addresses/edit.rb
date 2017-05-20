module Addresses
  class Edit < New

    page_url { |address| "#{BasePage.base_url}/addresses/#{address.id}/edit" }

    def on_page?
      browser.url[-4..-1] == 'edit'
    end

  end
end
