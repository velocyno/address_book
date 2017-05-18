module Addresses
  class Edit < New

    page_url { |address| "/addresses/#{address.id}/edit" }

    def on_page?
      browser.url[-4..-1] == 'edit'
    end

  end
end
