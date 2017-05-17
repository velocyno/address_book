module Addresses
  class Edit < New

    page_url { |address| "https://address-book-example.herokuapp.com/addresses/#{address.id}/edit" }

    def on_page?
      browser.url[-4..-1] == 'edit'
    end

  end
end
